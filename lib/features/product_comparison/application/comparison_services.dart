import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import '../domain/comparison_models.dart';

class StorageService {
  static const _key = 'comparativoSojaAtivo';
  
  Future<void> saveRelatorio(Relatorio relatorio) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(relatorio.toJson());
    await prefs.setString(_key, json);
  }
  
  Future<Relatorio?> loadRelatorio() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    try {
      return Relatorio.fromJson(jsonDecode(json));
    } catch (e) {
      debugPrint('Error loading report: $e');
      return null;
    }
  }
}

class ImageService {
  static Future<String> compressImage(File file, {int maxWidth = 1600, int quality = 92}) async {
    // Run in isolate to not block UI
    return await compute(_compressImageTask, {
      'path': file.path,
      'maxWidth': maxWidth,
      'quality': quality,
    });
  }

  static Future<String> _compressImageTask(Map<String, dynamic> params) async {
    final String path = params['path'];
    final int maxWidth = params['maxWidth'];
    final int quality = params['quality'];

    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) throw Exception('Erro ao decodificar imagem');
    
    // Redimensionar mantendo proporção
    if (image.width > maxWidth) {
      image = img.copyResize(image, width: maxWidth);
    }
    
    // Comprimir para JPEG
    final compressed = img.encodeJpg(image, quality: quality);
    
    // Converter para base64
    return base64Encode(compressed);
  }
}

class ROICalculator {
  static double calcularROI(double investimento, double retorno) {
    if (investimento == 0) return 0;
    return ((retorno - investimento) / investimento) * 100;
  }

  static String calcularRetornoTotal(double investimento, double retorno, double area) {
    double ganhoPorHa = retorno - investimento;
    if (area > 0) {
      double ganhoTotal = ganhoPorHa * area;
      return 'R\$ ${ganhoTotal.toStringAsFixed(2)}';
    }
    return 'R\$ ${ganhoPorHa.toStringAsFixed(2)}/ha';
  }
}
