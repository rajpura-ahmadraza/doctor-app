import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    // Scroll to bottom after the initial build has completed
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.scrollDown());

    return AppScaffold(
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: primary.withValues(alpha: .15), shape: BoxShape.circle),
                  child: const Center(child: Text('P', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 16, fontWeight: FontWeight.w700, color: primary))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Dr. Priya Sharma', style: TStyle.h3),
                  Row(children: [
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: success, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text('ClinixPro Clinic', style: TStyle.small),
                  ]),
                ])),
                IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline_rounded, color: dark500)),
              ]),
            ),
          ),
          const SizedBox(height: 8),

          // Notice banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFE65100)),
                const SizedBox(width: 8),
                Expanded(child: Text('Messages are replied during clinic hours (9 AM – 6 PM)', style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 11, color: Color(0xFFE65100)))),
              ]),
            ),
          ),
          const SizedBox(height: 8),

          // Messages
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.messages.length,
              itemBuilder: (_, i) => _messageBubble(context, controller.messages[i]),
            )),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: light.withValues(alpha: .8),
              border: Border(top: BorderSide(color: dark.withValues(alpha: .08))),
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(color: black300, borderRadius: BorderRadius.circular(24)),
                  child: TextField(
                    controller: controller.msgCtrl,
                    maxLines: null,
                    style: TStyle.body,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(fontFamily: 'HankenGrotesk', color: dark500, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.sendMessage,
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: primary.withValues(alpha: .4), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Obx(() => controller.sending.value
                      ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: light, strokeWidth: 2)))
                      : const Icon(Icons.send_rounded, color: light, size: 18)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _messageBubble(BuildContext context, Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: primary.withValues(alpha: .15), shape: BoxShape.circle),
              child: const Center(child: Text('P', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, fontWeight: FontWeight.w700, color: primary))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .72),
                  decoration: BoxDecoration(
                    color: isMe ? primary : light,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe ? null : Border.all(color: black200),
                    boxShadow: [BoxShadow(color: dark.withValues(alpha: .05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Text(msg['text']!, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, color: isMe ? light : dark, height: 1.4)),
                ),
                const SizedBox(height: 4),
                Text(msg['time']!, style: TStyle.small),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
