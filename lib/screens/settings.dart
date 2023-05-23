import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) onDifficultyChanged;
  final Function(bool) onToggleVibration;
  final Function(bool) onToggleSound;
  final bool Function() getVibration;
  final bool Function() getSound;
  final String Function() getDifficulty;

  const SettingsScreen({
    Key? key,
    required this.onDifficultyChanged,
    required this.onToggleVibration,
    required this.onToggleSound,
    required this.getVibration,
    required this.getSound,
    required this.getDifficulty,
  }) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String _selectedDifficulty;
  late bool _vibrationEnabled;
  late bool _soundEnabled;
  final List<String> _difficulties = ['Fácil', 'Médio', 'Difícil'];
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    _selectedDifficulty = widget.getDifficulty();
    _vibrationEnabled = widget.getVibration();
    _soundEnabled = widget.getSound();
    super.initState();
  }

  void changeDifficulty(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
    widget.onDifficultyChanged(_selectedDifficulty);
  }

  void toggleSound(bool value) {
    setState(() {
      debugPrint(value.toString());
      _soundEnabled = value;
      widget.onToggleSound(_soundEnabled);
    });
  }

  void toggleVibration(bool value) {
    setState(() {
      debugPrint(value.toString());
      _vibrationEnabled = value;
      widget.onToggleVibration(_vibrationEnabled);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opções de Dificuldade:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                children: _difficulties.map((difficulty) {
                  return RadioListTile<String>(
                    title: Text(
                      difficulty,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    activeColor: Colors.red,
                    value: difficulty,
                    groupValue: _selectedDifficulty,
                    onChanged: (value) {
                      changeDifficulty(value!);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12.0),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Opções de Áudio:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12.0),
              SwitchListTile(
                activeColor: Colors.red,
                title: const Text(
                  'Som',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: _soundEnabled,
                onChanged: toggleSound,
              ),
              SwitchListTile(
                activeColor: Colors.red,
                title: const Text(
                  'Vibração',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: _vibrationEnabled,
                onChanged: toggleVibration,
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
