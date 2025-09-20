
// Dart program for Input/Output and Loops
import 'dart:io';

void main() {
  print("Enter a number:");
  int? n = int.parse(stdin.readLineSync()!);

  print("Numbers from 1 to $n:");
  for (int i = 1; i <= n; i++) {
    print(i);
  }
}
