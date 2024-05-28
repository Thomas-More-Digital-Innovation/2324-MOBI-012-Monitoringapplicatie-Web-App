import 'dart:math';
import 'package:vector_math/vector_math.dart';

void qautToAngle(List<double> quaternion1, List<double>quaternion2) {

  // defining the different values of the quaternions separate
  // naming q[quaternion num.][which value]
  double q10 = quaternion1[0];
  double q11 = quaternion1[1];
  double q12 = quaternion1[2];
  double q13 = quaternion1[3];

  double q20 = quaternion2[0];
  double q21 = quaternion2[1];
  double q22 = quaternion2[2];
  double q23 = quaternion2[3];

  // make quaternion objects
  Quaternion q1 = Quaternion(q10, q11, q12, q13);
  Quaternion q2 = Quaternion(q20, q21, q22, q23);

  // convert from quaternions to rotation matrices
  Matrix3 rot1 = q1.asRotationMatrix();
  Matrix3 rot2 = q2.asRotationMatrix();

  // inverse the second rotation matrix
  double a = rot1[0];
  double b = rot1[1];
  double c = rot1[2];
  double d = rot1[3];
  double e = rot1[4];
  double f = rot1[5];
  double g = rot1[6];
  double h = rot1[7];
  double i = rot1[8];

  double rot2Det = rot1.invert();
  List<double> inverseRot2 = [(1/rot2Det * ((e*i) - (h*f))),(1/rot2Det * (-1 * ((b*i) - (h*c)))), (1/rot2Det * ((b*f) - (e*c))),
    (1/rot2Det * (-1 * ((d*i) - (g*f)))), (1/rot2Det * ((a*i) - (g*c))), (1/rot2Det * (-1 * ((a*f) - (d*c)))),
    (1/rot2Det * ((d*h) - (g*e))), (1/rot2Det * (-1 * ((a*h) - (g*b)))), (1/rot2Det * ((a*e) - (d*b)))];

  Matrix3 rot2Core = Matrix3.fromList(inverseRot2);

  // multiply to rotation quaternions
  Matrix3 endRot = rot2.multiplied(rot2Core);

  // correcte hoek in matrix --> enkele hoek [alpha]
  double trace = endRot[0] + endRot[4] + endRot[8];
  double radAngle = acos((trace - 1) / 2);
  double angle = degrees(radAngle);

  print(angle);

}