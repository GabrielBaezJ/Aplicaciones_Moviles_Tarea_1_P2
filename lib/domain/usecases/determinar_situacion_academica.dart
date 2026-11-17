class DeterminarSituacionAcademica {
  String ejecutar(double valor) {
    if (valor >= 14) return 'Aprobado';
    if (valor >= 9) return 'Recuperación';
    return 'Reprobado';
  }
}
