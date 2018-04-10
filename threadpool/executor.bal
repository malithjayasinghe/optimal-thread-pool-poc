package threadpool;

import ballerina/io;
import ballerina/time;
import ballerina/file;
import ballerina/math;





// Probability density function
// of Bounded Pareto distribtution
// parameters p - Lower bound, k upper bound, alpha - shape parameters
// where k<=x<=p and alpha >0
// return pdf(x)
function pdf (float k, float p, float alpha, float x) {
    if (checkRange(k, p, alpha, x)) {
        return;
    }
    return;
}


// Cumilative distribution function
// of Bounded Pareto distribtution
// parameters p - Lower bound, k upper bound, alpha - shape parameters
// where k<=x<=p and alpha >0
// return cdf(x)


function cdf (float k, float p, float alpha, float x) returns (float) {
    if (checkRange(k, p, alpha, x)) {
        return (1 - math:pow(k, alpha) * math:pow(x, -alpha))/(1-math:pow(k /p,alpha));
    }
    return 0.0;
}


// Inverse transform of cdf
// Bounded Pareto distribtution
// parameters p - Lower bound, k upper bound, alpha - shape parameters
// u = cdf(x)
// where k<=x<=p and alpha >0
// return x
public function inverseTransform (float k, float p, float alpha, float U) returns (float) {
    if (alpha > 0 && k > 0 && p > 0) {
        return math:pow((-U*math:pow(p,alpha)+ U*math:pow(k,alpha) + math:pow(p,alpha))/(math:pow(p,alpha)*math:pow(k,alpha)), -1/alpha);
    }
    return 0.0;
}

//check if the given values for the parameters are in the valid range
function checkRange (float k, float p, float alpha, float x) returns (boolean) {
    if (k >= x && x >= p && alpha <= 0) {
        io:println("Values should be in the range of : k<=x<=p and alpha >0");
        return false;
    }
    return true;
}

public type functionRecord {
            string functionName;
function () f;
};



public function main(string[] args) {

    if (lengthof args < 3) {
        io:println("ERROR: Please specify the number of warm-up iterations, benchmark iterations, result file name");
        return;
    }

    var warmupIterations = check <int>args[0];
    var benchmarkIterations = check <int>args[1];
    string resultFileName = <string>args[2];

    io:println("Starting");

    // executeBenchmarks(getForkJoinBenchmarkArray(), warmupIterations, benchmarkIterations, resultFileName);

    executeBenchmarks(getTypeBenchmarkArray(), warmupIterations, benchmarkIterations, resultFileName);
    io:println("\nTests End ");
}

function executeBenchmarks(functionRecord[] functionArray, int warmupIterations, int benchmarkIterations, string resultFileName)
{
    file:Path dirPath = file:getPath("TestResults");
    var dir2 = file:delete(dirPath);
    var dir = file:createDirectory(dirPath);

    file:Path filePath = file:getPath("TestResults/" + resultFileName + ".csv");
    var result = file:createFile(filePath);

    // write ReadMe
    string fileReadMeLocation = "TestResults/ReadMe.txt";
    io:ByteChannel channelR = io:openFile(fileReadMeLocation, "W");
    io:CharacterChannel charChannelR = check io:createCharacterChannel(channelR, "UTF-8");
    int resultWriteR = check charChannelR.writeCharacters("This test carried out with warmupIterations of " +
                                                          warmupIterations + " and benchmarkIterations of " + benchmarkIterations + ".", 0);

    string fileLocation = "TestResults/results.csv";

    //string fileLocation = "TestResults/" + resultFileName + ".csv";
    io:ByteChannel channel = io:openFile(fileLocation, "W");
    io:CharacterChannel charChannel = check io:createCharacterChannel(channel, "UTF-8");

    //  int resultWrite = check charChannel.writeCharacters("Function_Name,Start time,End time,Total time in ns,No. of Iterations,Average Latency in ns,TPS (operations/sec)", 0);

    int resultWrite = check charChannel.writeCharacters("Function_Name,Total Time (ms),Average Latency (ns),Throughput (operations/second) ", 0);

    foreach key, value in functionArray {

        var temp = value;
        time:Time warmupstartTime = time:currentTime();
        int i = 0;

        while (i < warmupIterations) {
            i = i + 1;
            function () f = value.f;
            f();
        }

        time:Time startTime = time:currentTime();

        i = 0;

        io:println(value.functionName);

        while (i < benchmarkIterations) {
            i = i + 1;
            function () f = value.f;
            f();
        }

        time:Time endTime = time:currentTime();

        resultWrite = check charChannel.writeCharacters("\n" + value.functionName + ",", 0);

        int totalTime = endTime.time - startTime.time;
        float totalTimeMilli = (totalTime / 1000000.0);

        resultWrite = check charChannel.writeCharacters(totalTimeMilli + ",", 0);

        float avgLatency = (<float>totalTime / <float>benchmarkIterations);

        resultWrite = check charChannel.writeCharacters(avgLatency + ",", 0);

        float tps = (1000000000.0 / avgLatency);

        resultWrite = check charChannel.writeCharacters(" " + tps, 0);
    }
}




public function getTypeBenchmarkArray() returns (functionRecord[]) {
    functionRecord[] functionArray = [];
    functionArray = [
                    {functionName:"benchmarkWorkLoadType1", f:benchmarkWorkLoad1},
                    {functionName:"benchmarkWorkloadType2", f:benchmarkWorkLoad2},
                    {functionName:"benchmarkWorkloadType3", f:benchmarkWorkLoad3},
                    {functionName:"benchmarkWorkloadType4", f:benchmarkWorkLoad4},
                    {functionName:"benchmarkWokkloadType5", f:benchmarkWorkLoad5}
                    ];

    return functionArray;

}

public function benchmarkWorkLoad1() {

    float k = 1000;
    float p = 10000000;
    float alpha = 2;
    int lastCount = math:round(inverseTransform(k, p, alpha, math:random()));
    int i = 0;
    while (i < lastCount)
    {
        i++;
    }
}

public function benchmarkWorkLoad2() {

    float k = 1000;
    float p = 10000000;
    float alpha = 2;
    int lastCount = math:round(inverseTransform(k, p, alpha, math:random()));
    int i = 0;
    while (i < lastCount)
    {
        i++;
    }


}

public function benchmarkWorkLoad3() {

    float k = 1000;
    float p = 10000000;
    float alpha = 1.5;
    int lastCount = math:round(inverseTransform(k, p, alpha, math:random()));
    int i = 0;
    while (i < lastCount)
    {
        i++;
    }

}

public function benchmarkWorkLoad4() {

    float k = 1000;
    float p = 10000000;
    float alpha = 0.8;
    int lastCount = math:round(inverseTransform(k, p, alpha, math:random()));
    int i = 0;
    while (i < lastCount)
    {
        i++;
    }

}

public function benchmarkWorkLoad5() {

    float k = 1000;
    float p = 10000000;
    float alpha = 0.4;
    int lastCount = math:round(inverseTransform(k, p, alpha, math:random()));
    int i = 0;
    while (i < lastCount)
    {
        i++;
    }

}





