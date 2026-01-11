/// Constantes de zoom para uso agrícola em mapas
///
/// Essas constantes definem limites adequados para visualização de áreas
/// agrícolas em dispositivos móveis (iOS e Android) para uso em campo.
library;

/// Zoom mínimo: evita visualizar o globo inteiro, mantém contexto territorial
/// Nível de país ou macro-região do Brasil
const double kAgriculturalMinZoom = 4.0;

/// Zoom máximo: evita zoom urbano (ruas/edifícios), adequado para talhões
/// Permite visualizar polígonos e áreas de plantio sem detalhes urbanos
const double kAgriculturalMaxZoom = 17.0;

/// Zoom ideal para centralizar GPS: intermediário para ações de campo
/// Garante área suficiente para operações de ocorrência, marketing e desenho
const double kAgriculturalLocationZoom = 14.0;

/// Zoom inicial padrão quando não há localização do usuário
const double kAgriculturalDefaultZoom = 13.0;
