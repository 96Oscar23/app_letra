import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum SongOcrStage {
  analyzingImage,
  extractingText,
}

abstract class SongOcrService {
  Future<String> recognizeText(
    String imagePath, {
    void Function(SongOcrStage stage)? onStageChanged,
  });
}

class MlKitSongOcrService implements SongOcrService {
  const MlKitSongOcrService();

  @override
  Future<String> recognizeText(
    String imagePath, {
    void Function(SongOcrStage stage)? onStageChanged,
  }) async {
    onStageChanged?.call(SongOcrStage.analyzingImage);
    final inputImage = InputImage.fromFilePath(imagePath);

    onStageChanged?.call(SongOcrStage.extractingText);
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } finally {
      textRecognizer.close();
    }
  }
}
