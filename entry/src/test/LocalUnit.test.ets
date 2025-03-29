import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { trimEndZero } from '../main/ets/utils/Util';
import { asset } from '@kit.AssetStoreKit';

export default function localUnitTest() {

  let currentDate=new Date(2025,0,1);

 // currentDate.setFullYear(currentDate.getFullYear()-1);
  currentDate.setMonth(-1)

  console.log("hi")
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);

      let a1= trimEndZero("100.0");
      expect(a1==="100").assertTrue();
      let a2= trimEndZero("100.00");
      expect(a2==="100").assertTrue();
      let a3= trimEndZero("100.");
      expect(a3==="100").assertTrue();
      let a4= trimEndZero("100.12");
      expect(a4==="100.12").assertTrue();
      let a5= trimEndZero("100");
      expect(a5==="100").assertTrue();
      let a6= trimEndZero("100.001");
      expect(a6==="100.001").assertTrue();
      let a7= trimEndZero("100.20");
      expect(a7==="100.2").assertTrue();
      let a8= trimEndZero("0.00");
      expect(a8==="0").assertTrue();
      let a9= trimEndZero("");
      expect(a9==="").assertTrue();

      let a10= trimEndZero(".");
      expect(a10==="").assertTrue();

    });


  });
}