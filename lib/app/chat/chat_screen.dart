import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'chat_controller.dart';

/// ── Chat Screen ─────────────────────────────────────────────────────────────
/// Renders the clinic messaging system screen. It initializes the controller,
/// lays out the custom header, notice banner, message history list, and input area.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and initialize the ChatController
    final controller = Get.put(ChatController());

    // Schedule scroll to bottom after the initial widget build finishes
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.scrollDown());

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header Widget
            const ChatHeaderWidget(),
            const SizedBox(height: 8),

            // 2. Active Office-hours Notice Banner
            const ChatNoticeBannerWidget(),
            const SizedBox(height: 8),

            // 3. Scrollable List of messages
            Expanded(
              child: ChatMessageListWidget(controller: controller),
            ),

            // 4. Message typing Input text field controls
            ChatInputWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}

/// ── Chat Header Widget ──────────────────────────────────────────────────────
/// A glassmorphic top header containing navigation-back controls, Doctor details
/// (avatar initial, name, clinic branch), and an informational toggle button.
class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 10),

            // Doctor Initial Avatar representation
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontFamily: 'HankenGrotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Doctor Info Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dr. Priya Sharma', style: TStyle.h3),
                  Row(
                    children: [
                      // Active indicator badge
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('ClinixPro Clinic', style: TStyle.small),
                    ],
                  ),
                ],
              ),
            ),

            // Secondary Action details button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline_rounded, color: dark500),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Chat Notice Banner Widget ───────────────────────────────────────────────
/// A prominent alert panel notifying the user about doctor response operational hours.
class ChatNoticeBannerWidget extends StatelessWidget {
  const ChatNoticeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFE65100)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Messages are replied during clinic hours (9 AM – 6 PM)',
                style: TextStyle(
                  fontFamily: 'HankenGrotesk',
                  fontSize: 11,
                  color: Color(0xFFE65100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Chat Message List Widget ───────────────────────────────────────────────
/// Obx dynamic list view observer tracking message list state updates.
class ChatMessageListWidget extends StatelessWidget {
  final ChatController controller;

  const ChatMessageListWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          controller: controller.scrollCtrl,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.messages.length,
          itemBuilder: (_, i) => ChatMessageBubbleWidget(
            messageData: Map<String, dynamic>.from(controller.messages[i]),
          ),
        ));
  }
}

/// ── Chat Message Bubble Widget ──────────────────────────────────────────────
/// An individual chat bubble styled depending on whether it was sent by the current
/// user or the doctor, complete with time indicators and initials avatars.
class ChatMessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> messageData;

  const ChatMessageBubbleWidget({
    super.key,
    required this.messageData,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = messageData['isMe'] as bool? ?? false;
    final text = messageData['text'] as String? ?? '';
    final time = messageData['time'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Display Doctor avatar on incoming messages
          if (!isMe) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontFamily: 'HankenGrotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble body content wrapper
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .72,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? primary : light,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe ? null : Border.all(color: black200),
                    boxShadow: [
                      BoxShadow(
                        color: dark.withValues(alpha: .05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 13,
                      color: isMe ? light : dark,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(time, style: TStyle.small),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// ── Chat Input Widget ───────────────────────────────────────────────────────
/// Interactive text editor field containing a dynamic send actions button,
/// with reactive busy/sending state updates.
class ChatInputWidget extends StatelessWidget {
  final ChatController controller;

  const ChatInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: light.withValues(alpha: .8),
        border: Border(top: BorderSide(color: dark.withValues(alpha: .08))),
      ),
      child: Row(
        children: [
          // Expandable text form entry container
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: black300,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller.msgCtrl,
                maxLines: null,
                style: TStyle.body,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    fontFamily: 'HankenGrotesk',
                    color: dark500,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send message action button
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: .4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Obx(() => controller.sending.value
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: light,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: light, size: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
