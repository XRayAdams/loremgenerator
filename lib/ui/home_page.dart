// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loremgenerator/ui/number_editor.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/widgets.dart';

import '../services/generator.dart';
import '../services/preferences_service.dart';
import 'about_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _outputController = TextEditingController();
  final _generator = LoremGenerator();
  final _preferencesService = PreferencesService();

  int _wordCount = 0;
  int _sentenceCount = 0;
  int _paragraphCount = 0;
  bool _startWithLorem = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    _wordCount = await _preferencesService.getMaxWords();
    _sentenceCount = await _preferencesService.getMaxSentences();
    _paragraphCount = await _preferencesService.getMaxParagraphs();
    _startWithLorem = await _preferencesService.getStartWithLorem();

    setState(() {});
  }

  @override
  void dispose() {
    // _inputController.removeListener(_onInputChanged);
    //_inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        actions: [
          YaruOptionButton(
            child: const Icon(YaruIcons.menu),
            onPressed: () {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  offset.dx + renderBox.size.width - 190,
                  offset.dy + 50,
                  offset.dx + renderBox.size.width,
                  offset.dy,
                ),
                items: [const PopupMenuItem(value: "about", child: Text("About..."))],
              ).then((value) {
                if (value == "about") {
                  showDialog(context: context, builder: (context) => const CustomAboutDialog());
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NumberEditor(
                  title: 'Max Words',
                  value: _wordCount,
                  onChanged: (value) {
                    setState(() {
                      _wordCount = value;
                    });
                    _preferencesService.saveMaxWords(value);
                  },
                  minValue: 3,
                  maxValue: 25,
                ),
                const SizedBox(width: 16),
                NumberEditor(
                  title: 'Max Sentences',
                  value: _sentenceCount,
                  onChanged: (value) {
                    setState(() {
                      _sentenceCount = value;
                    });
                    _preferencesService.saveMaxSentences(value);
                  },
                  minValue: 1,
                  maxValue: 20,
                ),
                const SizedBox(width: 16),
                NumberEditor(
                  title: 'Paragraphs',
                  value: _paragraphCount,
                  onChanged: (value) {
                    setState(() {
                      _paragraphCount = value;
                    });
                    _preferencesService.saveMaxParagraphs(value);
                  },
                  minValue: 1,
                  maxValue: 40,
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _startWithLorem = !_startWithLorem;
                        });
                        _preferencesService.saveStartWithLorem(_startWithLorem);
                      },
                      child: Text("Start with lorem", style: Theme.of(context).textTheme.titleSmall),
                    ),
                    YaruSwitch(
                      value: _startWithLorem,
                      onChanged: (value) {
                        setState(() {
                          _startWithLorem = value;
                        });
                        _preferencesService.saveStartWithLorem(value);
                      },
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: kYaruPagePadding),
            Expanded(
              child: TextField(
                controller: _outputController,
                readOnly: true,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: 'Output',
                ),
              ),
            ),
            const SizedBox(height: kYaruPagePadding),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: () {
                      _outputController.text = _generator.generate(
                        _wordCount,
                        _sentenceCount,
                        _paragraphCount,
                        _startWithLorem,
                      );
                      setState(() {

                      });
                    },
                    child: Text("Generate"),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed:  _outputController.text.isEmpty
                        ? null
                        : () {
                      Clipboard.setData(ClipboardData(text: _outputController.text));
                    },
                    child: Text("Copy"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
