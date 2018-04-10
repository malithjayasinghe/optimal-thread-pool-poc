package threadpool;

import ballerina/io;
import ballerina/time;
import ballerina/file;
import ballerina/math;
import ballerina/http;


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


@Description {value:"Attributes associated with the service endpoint is defined here."}
endpoint http:Listener serviceEP {
    port:9090
};

@Description {value:"By default Ballerina assumes that the service is to be exposed via HTTP/1.1."}
service<http:Service> hello bind serviceEP {
    @Description {value:"All resources are invoked with arguments of server connector and request"}
    sayHello (endpoint conn, http:Request req) {
        http:Response res = new;
        // A util method that can be used to set string payload.
        res.setStringPayload("Hello, World!");
        // Sends the response back to the client.
        _ = conn -> respond(res);
    }
}