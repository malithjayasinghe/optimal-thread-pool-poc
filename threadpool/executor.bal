package threadpool;

import ballerina/io;
import ballerina/time;
import ballerina/file;

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
        time:Time warmupstartTime = time:nanoTime();
        int i = 0;

        while (i < warmupIterations) {
            i = i + 1;
            function () f = value.f;
            f();
        }

        time:Time startTime = time:nanoTime();

        i = 0;

        io:println(value.functionName);

        while (i < benchmarkIterations) {
            i = i + 1;
            function () f = value.f;
            f();
        }

        time:Time endTime = time:nanoTime();

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