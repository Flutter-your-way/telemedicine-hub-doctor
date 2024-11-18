import 'dart:developer';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';

class MeetingScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String channelName;

  const MeetingScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.channelName,
  });

//   @override
  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  AgoraClient? client;
  String appId = "9b6433f0a0b6467da1416c44a6c576ae";
  bool isLoading = true;
  String? error;
  String channelName = '';
  bool isDisposing = false;

  @override
  void initState() {
    super.initState();
    channelName = extractAfterChannel(widget.channelName);
    log("Generated Channel Name: $channelName");
    initializeAgora();
  }

  String extractAfterChannel(String input) {
    const prefix = "telemedicine-hub-doctor-patient-channel-";
    if (input.startsWith(prefix)) {
      return input.substring(prefix.length);
    }
    throw Exception("Input string does not contain the expected prefix.");
  }

  Future<void> initializeAgora() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      var res = await Provider.of<HomeProvider>(context, listen: false)
          .getAgoraAccessToken(channelName: channelName);

      if (!mounted) return;

      if (res.success && res.data['agoraAccessToken'] != null) {
        final token = res.data['agoraAccessToken'] as String;
        log("Token Name: $token");

        final newClient = AgoraClient(
          agoraConnectionData: AgoraConnectionData(
            username: Provider.of<AuthProvider>(context, listen: false)
                .usermodel!
                .name
                .toString(),
            appId: appId,
            channelName: channelName,
            tempToken: token,
            rtmEnabled: false, // Disable RTM to avoid conflicts
          ),
          enabledPermission: [Permission.microphone, Permission.camera],
        );

        try {
          await newClient.initialize();

          if (mounted) {
            setState(() {
              client = newClient;
              isLoading = false;
            });
          }
        } catch (e) {
          log("Initialize error: $e");
          throw Exception("Failed to initialize Agora client: $e");
        }
      } else {
        throw Exception(res.msg ?? 'Failed to get Agora token');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to initialize video call: $e';
          isLoading = false;
        });
      }
      log("Agora Error: $e");
      Fluttertoast.showToast(msg: 'Failed to initialize video call');
    }
  }

  Future<void> cleanupCall() async {
    if (isDisposing) return;
    isDisposing = true;

    try {
      if (client != null) {
        // Stop preview first
        try {
          await client!.engine.stopPreview();
        } catch (e) {
          log("Stop preview error: $e");
        }

        // Leave channel
        try {
          await client!.engine.leaveChannel();
        } catch (e) {
          log("Leave channel error: $e");
        }

        // Small delay before release
        await Future.delayed(const Duration(milliseconds: 500));

        // Release engine
        try {
          await client!.engine.release();
        } catch (e) {
          log("Engine release error: $e");
        }

        client = null;
      }
    } catch (e) {
      log("Cleanup error: $e");
    }
  }

  Future<bool> _onWillPop() async {
    await cleanupCall();
    return true;
  }

  @override
  void dispose() {
    cleanupCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meeting'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await cleanupCall();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing video call...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: initializeAgora,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (client == null) {
      return const Center(
        child: Text('Failed to initialize video call'),
      );
    }

    return Stack(
      children: [
        AgoraVideoViewer(
          client: client!,
          layoutType: Layout.floating,
          showNumberOfUsers: true,
          showAVState: true,
        ),
        AgoraVideoButtons(
          client: client!,
          enabledButtons: const [
            BuiltInButtons.toggleCamera,
            BuiltInButtons.switchCamera,
            BuiltInButtons.toggleMic,
            BuiltInButtons.callEnd,
          ],
          extraButtons: const [],
          onDisconnect: () async {
            await cleanupCall();
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          buttonAlignment: Alignment.bottomCenter,
          verticalButtonPadding: 50,
          // horizontalButtonPadding: 10,
        ),
      ],
    );
  }
}
