@doc raw"""
# RANDOM NUMBERS
"Random numbers" as the name suggests, "are numbers chosen by chance, i.e. randomly, from a
set of numbers". However, in computer programming, these numbers are not really chosen by
"chance" but rather by using a process known as *random number generation*.

Random number generation is a process by which a sequence of numbers that cannot be
reasonably predicted better than by random chance is generated, often by means of
a *random number generator* (RNG). This means that the particular outcome sequence may
contain some patterns detectable in hindsight but unpredictable to foresight.

A random number generator (RNG) is a hardware device or software algorithm designed to
generate a random number taken from a limited or unlimited distribution and output it. These
numbers should not display any distinguishable patterns in their appearance or generation,
hence the word "random". The two main types of random number generators
are **pseudo-random number generators** and **true-random number generators**.

# Pseudo-Random Number Generators (PRNGs)
A pseudo-random number generator (PRNG), also known as a deterministic random bit generator
(DRBG), is a computational algorithm for generating a sequence of numbers whose properties
approximate the properties of sequences of random numbers.

The PRNG-generated sequence is not "truly" random because, on a completely deterministic
machine, you can ONLY produce apparently random results. Why "apparently" random results?
Because the end results obtained are, in fact, completely determined by an initial value,
also known as the *seed value* or key. Therefore, if you knew the seed value and how the
algorithm works, you could reproduce these seemingly random results. So, the random numbers
it produces are not "truly" random, even when the results may be sufficiently complex to
make the pattern difficult to identify.

Good statistical properties are a central requirement for the output of a PRNG. In general,
careful mathematical analysis is required to have any confidence that a PRNG generates
numbers that are sufficiently close to random to suit the intended use.

Several [computational algorithms for pseudo-random number generation]
(https://en.wikipedia.org/wiki/List_of_random_number_generators) exist, e.g. Mersenne
Twister (MT), Xorshift, Squares RNG, etc. but they all fall short of the goal of "true"
randomness, although they may meet with varying success in some of the statistical tests for
randomness intended to measure how unpredictable their results are (that is, to what degree
their patterns are discernible).

Though generally unusable for applications such as cryptography, PRNGs are important in
practice for their speed in number generation and their reproducibility.

# True-Random Number Generators (TRNGs)
Not all randomness is pseudo, however. There are ways that machines can generate truly
random numbers. The importance of true randomness cannot be underestimated. A true random
number generator cannot rely on mathematical equations and computational algorithms to get a
random number. If there is an equation involved, then it is not random. To get true
randomness, we must rely on unpredictable processes rather than human-defined patterns.

Examples of unpredictable processes are atmospheric noise, thermal noise, cosmic background
radiation, etc. These are used in hardware-random number generators (HRNGs) that generate
random numbers, wherein each generation is a function of the current value of a physical
environment's attribute that is constantly changing in a manner that is practically
impossible to model.

True random numbers may seldomly be predicted correctly or may even be slightly biased
towards a direction, but the important point is that they're not generated by a
deterministic algorithm.

While HRNGs can generate true randomness, they are typically slow when compared to PRNGs for
generating a large sequence of random numbers.

# Applications Of Random Numbers
In applications where unpredictability is a paramount feature, such as in security
applications, HRNGs are generally preferred over PRNGs, where feasible.

However, the generation of pseudo-random numbers is an important and common task in computer
programming. While applications requiring a high degree of apparent randomness as a
paramount feature are necessary, many other operations only need a modest amount of
unpredictability. Some simple examples might be:

- presenting a user with a "random quote of the day",
- determining which way a computer-controlled adversary might move in a computer game,
- generating a sequence of numbers to test the correctness of a function or algorithm.

Moreover, PRNGs are faster than TRNGs. And because of their deterministic nature, they are
useful when you need to replay a sequence of random events. This helps a great deal in code
testing, for example.

Random number implementations in Julia are provided by the `Random` module, which can be
loaded with `using Random`. The PRNG algorithm used by default in the `Random` module is
[Xoshiro256++](https://prng.di.unimi.it), with per-`Task` state. Other RNG types can be
plugged in by inheriting the `AbstractRNG` type, which can then be used to obtain multiple
streams of random numbers.

The PRNGs exported by the `Random` package are:

- `TaskLocalRNG`: a token that represents the use of the currently active Task-local stream,
  deterministically seeded from the parent task, or by RandomDevice (with system randomness)
  at program start.

- `Xoshiro`: enerates a high-quality stream of random numbers with a small state vector and
  high performance using the Xoshiro256++ algorithm.

- `RandomDevice`: used for OS-provided entropy. This may be used for cryptographically
  secure random numbers (CS(P)RNG).

- `MersenneTwister`: an alternate high-quality PRNG that was the default in older versions
  of Julia and is also quite fast, but requires much more space to store the state vector
  and generate a random sequence.

Most functions related to random generation accept an optional AbstractRNG object as the
first argument. Some also accept dimension specifications `dims...` (which can also be given
as a tuple) to generate arrays of random values. In a multi-threaded program, you should
generally use different RNG objects from different threads or tasks to be thread-safe.
However, the default RNG is thread-safe as of Julia 1.3 (using a per-thread RNG up to
version 1.6, and per-task thereafter).

The provided RNGs can generate uniform random numbers of the following types: `Float16`,
`Float32`, `Float64`, `BigFloat`, `Bool`, `Int8`, `UInt8`, `Int16`, `UInt16`, `Int32`,
`UInt32`, `Int64`, `UInt64`, `Int128`, `UInt128`, `BigInt` (or complex numbers of those
types). Random floating point numbers are generated uniformly in ``[0, 1)``. As `BigInt`
represents unbounded integers, the interval must be specified (e.g. `rand(big.(1:6))`).

Additionally, normal and exponential distributions are implemented for some `AbstractFloat`
and `Complex` types. See `randn` and `randexp` for details.

To generate random numbers from other distributions, see the
[`Distributions.jl`](https://juliastats.org/Distributions.jl/stable) package.

!!! warning
    Because the precise way in which random numbers are generated is considered an
    implementation detail, bug fixes and speed improvements may change the stream of numbers
    that is generated after a version change. Relying on a specific seed or generated stream
    of numbers during unit testing is thus discouraged - consider testing properties of the
    methods in question instead.

# Hooking into the Random API
There are two mostly orthogonal ways to extend `Random` functionalities:

(1.) generating random values of custom types.

(2.) creating new generators.

The API for (1.) is quite functional, but is relatively recent, so it may still have to
evolve in subsequent releases of the `Random` module. For example, it's typically sufficient
to implement one `rand` method to have all other usual methods work automatically.
    
The API for (2.) is still rudimentary and may require more work than is strictly necessary
from the implementor to support usual types of generated values.

See https://docs.julialang.org/en/v1/stdlib/Random/#Hooking-into-the-Random-API for the
"how-to" implementation on these.
"""
function randoms(; extmod=false)
    methods = [
        "Methods" => [
            "Generating"                             =>[
                "Random.bitrand", "Random.randexp", "Random.randexp!", "Random.rand",
                "Random.rand!", "Random.randn", "Random.randn!", "Random.randstring"
            ]
            "Subsequences, Permutations & Shuffling" => [
                "Random.randcycle", "Random.randcycle!", "Random.randperm",
                "Random.randperm!", "Random.randsubseq", "Random.randsubseq!",
                "Random.shuffle", "Random.shuffle!"
            ]
            "Others"            => [
                "Random.default_rngˣ", "Random.ltm52ˣ", "Random.seed!ˣ"
            ]
        ]
    ]
    types = [
        "Types" => [
            "Random.AbstractRNG", "Random.MersenneTwister", "Random.RandomDevice",
            "Random.SamplerSimpleˣ", "Random.SamplerTrivialˣ", "Random.SamplerTypeˣ",
            "Random.Samplerˣ", "Random.TaskLocalRNG", "Random.Xoshiro"
        ]
    ]
    _print_names(methods, types)
end
