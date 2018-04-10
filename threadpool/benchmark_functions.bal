package threadpool;

import ballerina.io;

functionRecord[] functionArray = [];

public function getTypeBenchmarkArray() returns (functionRecord[]) {

    functionArray = [
                    {functionName:"benchmarkWorkLoadType1", f:benchmarkWorkLoad1},
                    {functionName:"benchmarkWorkloadType2", f:benchmarkWorkLoad2},
                    {functionName:"benchmarkWorkloadType3", f:benchmarkWorkLoad3},
                    {functionName:"benchmarkWorkloadType4", f:benchmarkWorkLoad4},
                    {functionName:"benchmarkWokkloadType5", f:benchmarkWorkload5},
                    {functionName:"benchmarkWorkloadTYpe6", f:benchmarkWorkload6}
                    ];

    return functionArray;

}

public function benchmarkWorkLoad1() {

    float k = 1;
    float  p = 10000000;
    float alpha = 2;
    int i = math.round(inverseTransform(k,p,alpha,math:random()));
    while (i < 0)
    {
        i++;
    }
}

public function benchmarkWorkLoad1() {


}

public function benchmarkWorkLoad2() {



}

public function benchmarkWorkLoad3() {



}



