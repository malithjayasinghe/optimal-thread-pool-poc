

package threadpool;

import ballerina/io;
import ballerina/math;


function setup()
{

    // set the number of samples to draw
    int size = 1000;

    // set parameters of the distribution
    float k = 0.1; // k should be greater than zero
    float p = 10; // p > k
    float alpha = 2; // alpha > 0

    // initiate array to store random values
    float[] U =[];
    // initiate array to store x values
    float[] x =[];
    // re-calculated U values from sampled X values
    float[] U_x =[];

    // draw samples
    int i = 0;
    while (i < size) {
        U[i] = math:random();
        x[i] = inverseTransform(k, p, alpha, U[i]);

        // lets re calculate U from sampled x
        U_x[i] = cdf(k, p, alpha, x[i]);
        i = i + 1;
    }

    io:println("Random CDF values (U)");
    
    io:println("Sampled x values");
    
    io:println("U values by substituting sampled x values");
    

}



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
function inverseTransform (float k, float p, float alpha, float U) returns (float) {
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


// print float array




