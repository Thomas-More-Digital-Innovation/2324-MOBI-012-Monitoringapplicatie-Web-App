import 'dart:math';

class QuatCalculator {
  final List<dynamic> quaternion1;
  final List<dynamic> quaternion2;

  QuatCalculator(this.quaternion1, this.quaternion2);
}

double calculateQuaternionAngle(
    List<double> quaternion1, List<double> quaternion2) {
  // Calculate magnitudes
  double magnitudeQuaternion1 = sqrt(pow(quaternion1[0], 2) +
      pow(quaternion1[1], 2) +
      pow(quaternion1[2], 2) +
      pow(quaternion1[3], 2));
  double magnitudeQuaternion2 = sqrt(pow(quaternion2[0], 2) +
      pow(quaternion2[1], 2) +
      pow(quaternion2[2], 2) +
      pow(quaternion2[3], 2));

  // Calculate dot product
  double dotProduct = quaternion1[0] * quaternion2[0] +
      quaternion1[1] * quaternion2[1] +
      quaternion1[2] * quaternion2[2] +
      quaternion1[3] * quaternion2[3];

  // Calculate angle in radians
  double angleRadians =
      2 * acos(dotProduct / (magnitudeQuaternion1 * magnitudeQuaternion2));

  // Convert radians to degrees
  double angleDegrees = angleRadians * (180 / pi);

  return angleDegrees;
}

/*double calculateAngle(List<double> q1, List<double> q2) {

  double dotProduct = q1[0] * q2[0] + q1[1] * q2[1] + q1[2] * q2[2];
  double magnitudeV1 = sqrt(q1[0] * q1[0] + q1[1] * q1[1] + q1[2] * q1[2]);
  double magnitudeV2 = sqrt(q2[0] * q2[0] + q2[1] * q2[1] + q2[2] * q2[2]);
  double cosAngle = dotProduct / (magnitudeV1 * magnitudeV2);

  cosAngle = cosAngle.clamp(-1.0, 1.0);

  return acos(cosAngle) * (180 / pi);
}*/

/*
void main() {
  QuatCalculator q1 = QuatCalculator(1, 0, 1, 0);
  QuatCalculator q2 = QuatCalculator(1, 0.5, 0.5, 0.5);

  List<List<double>> matrix1 = q1.toRotationMatrix();
  List<List<double>> matrix2 = q2.toRotationMatrix();

  double angle = calculateAngle(
      [matrix1[0][0], matrix1[1][0], matrix1[2][0]],
      [matrix2[0][0], matrix2[1][0], matrix2[2][0]]
  );

  print('The angle between the two corners on the x-axis is: $angle degrees');
}*/
