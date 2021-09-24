import 'dart:ffi';

import 'dart:io';

// typedef CPPFunction = Int32 Function(Int32 a, Int32 b);
// typedef DartFunction = int Function(int a, int b);

class AppFFI {

  //Performans için singleton pattern kullanmalıyız.
  //Her seferinde FFI kütüphanelerini çağırmak yerine 1 defa çağırıp istediğimiz zaman kullanabiliriz.
  //Singleton pattern yapmaz isek performansta ciddi düşüşlükler hissedeceksinizdir.
  //Bu düşüşlükler gözle görülür olmasa da çok sık kullanılan bir methodda bu yavaşlık hissedilebilir.

  static final AppFFI _AppFFI = AppFFI._internal();
  late DynamicLibrary nativeAddLib;
  late Function factorialFFI;

  factory AppFFI() {
    return _AppFFI;
  }

  AppFFI._internal() {
    //Kütüphanenin çağırılması
    nativeAddLib = Platform.isAndroid ? DynamicLibrary.open("libcalculator.so") : DynamicLibrary.process();
  }

  int sum({required int a, required int b}) {
    //Öncelikle C++ ile yazılan fonksiyonu çağırmamız gerekir.
    //Bu fonksiyonu nativeAddLib.lookup methodu ile çağırıp
    //Generic olarak fonksiyonun tipini belirlemeliyiz.
    //C++ da yazmış olduğumuz kod a ve b adında 2 parametre alır ve bu parametreler int32 değerinde olup
    //Geri dönüş tipi ise yine int32 tipindedir.
    final sumCPPFunction = nativeAddLib.lookup<NativeFunction<Int32 Function(Int32 a, Int32 b)>>('sum');
    //Oluşturduğumuz C++ fonksiyonunu artık dart dilinin anlayacağı bir fonksiyon tipine dönüştürmemiz gerekir.
    //Bunun için C++ tipindeki fonksiyonu tip dönüşümü yaparak Dart dilindeki bir fonksiyona çevirmemiz gerekir.
    //dilerseniz sumWithType methodunda bulunan kodlama stilini kullanabilirsiniz.
    final apiFunction = sumCPPFunction.asFunction<int Function(int a, int b)>();
    //oluşturduğumuz C++ fonksiyonunu dart methodu ile çağırıp sonucu result değişkenine atayalım
    final int result = apiFunction(a, b);
    //result değerini geriye dönelim.
    return result;
  }

  // int sumWithType({required int a, required int b}) {
  //   final sumCPPFunction = nativeAddLib.lookup<NativeFunction<CPPFunction>>('sum');
  //   final apiFunction = sumCPPFunction.asFunction<DartFunction>();
  //   final int result = apiFunction(9, 9);
  //   return result;
  // }

  void initializeFactorialFunctions() {
    final factorialCPPFunction = nativeAddLib.lookup<NativeFunction<Int32 Function(Int32 a)>>('factorial');
    factorialFFI = factorialCPPFunction.asFunction<int Function(int a)>();
  }

  int factorial({required int a}) {
    return factorialFFI(a);
  }
}
