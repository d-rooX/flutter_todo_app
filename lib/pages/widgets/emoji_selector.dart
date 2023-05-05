import 'package:flutter/material.dart';

import 'bg_icon.dart';

final List<String> emojis =
    "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵"
        .split(' ');

class EmojiSelector extends StatefulWidget {
  const EmojiSelector({Key? key, required this.onChange, this.initialEmoji}) : super(key: key);
  final String? initialEmoji;
  final Function(String emoji) onChange;

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  String? selectedEmoji;
  int? selectedEmojiIndex;

  @override
  Widget build(BuildContext context) {
    selectedEmoji ??= widget.initialEmoji;
    selectedEmojiIndex ??= emojis.indexOf(selectedEmoji ?? '');

    return SizedBox(
      height: 38,
      width: double.maxFinite,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            widget.onChange(emojis[index]);
            setState(() => selectedEmojiIndex = index);
          },
          child: BackgroundIcon(
            color: index == selectedEmojiIndex ? Colors.orange : Colors.grey.shade200,
            child: Text(emojis[index], style: const TextStyle(fontSize: 22)),
          ),
        ),
      ),
    );
  }
}
