libsmatrix
==========

A thread-safe two dimensional sparse matrix data structure with C, Java and Ruby bindings.
It was created to make loading and accessing medium sized (10GB+) matrices in boxed languages
like Java/Scala or Ruby easier.

While the chosen internal storage format (nested hashmaps) is neither the most memory-efficient
nor extremely fast in terms of access/insert time it seems to be a good tradeoff between these
two goals.

A libsmatrix sparse matrix features two modes of operation; a memory-only mode in which all data
is kept in main memory and a mode in which the data is stored on disk and only a pool of recently
used rows is kept in memory. In this mode the data is persisted across program restarts. It also
allows you to handle datasets larger than your available main memory.

#### Documentation

+ [Getting Started](#getting-started)
+ [C API](#c-api)
+ [Java/Scala API](#fnord)
+ [Ruby API](#ruby-api)
+ [Internals](#internals)
+ [Benchmarks](#benchmarks)
+ [Examples](#examples)
+ [License](#license)


Getting Started (Building)
--------------------------

There are multiple ways to install libsmatrix:

### Compile from source

This will produce a single shared object "libsmatrix.so" file that exports all calls documented
in "C API" as well as MRI ruby and Java JNI bindings if their respective header files (ruby.h,
jni.h) are found:

1) Compile

    $ ./configure
    $ make

2) Run tests (optional, requires java and ruby)

    $ make test

3) Install into system

    $ make install

4) Compile examples (optional)

    $ make examples


### Import artifact via Maven/sbt (java/scala)

Currently the maven artifact only contains the binding glue code and doesn't actually build
the native shared object. You need to compile & install "libsmatrix.so" yourself on the target
host, otherwise you'll get a "UnsatisfiedLinkError".

Import artifact via sbt:

    resolvers += "sbt-libsmatrix-repo" at "https://raw.github.com/paulasmuth/libsmatrix/mvn-repo/"

    libraryDependencies += "com.paulasmuth.libsmatrix" % "libsmatrix" % "0.1-SNAPSHOT"

Import artifact via Maven2 (put this into your pom.xml):

    <repository>
      <id>libsmatrix-mvn-repo</id>
      <url>https://raw.github.com/paulsmuth/libsmatrix/mvn-repo/</url>
      <snapshots>
        <enabled>true</enabled>
        <updatePolicy>always</updatePolicy>
      </snapshots>
    </repository>

To build the maven artifact from source, check out libsmatrix and run this:

    $ make build_maven


### Import gem via rubygems (ruby only)

This will install the ruby bindings and compile the native shared object:

    $ gem install libsmatrix

To use libsmatrix in your project, require it like this:

    require "libsmatrix"

To build the rubygem from source, check out libsmatrix and run this:

    $ make build_gem


C API
-----

Open a smatrix (if filename is NULL, use in memory only mode; otherwise open or create file)

    smatrix_t* smatrix_open(const char* fname);

Close a smatrix:

    void smatrix_close(smatrix_t* self);

Get, Set, Increment, Decrement a (x,y) position. _All of the methods are threadsafe_

    uint32_t smatrix_get(smatrix_t* self, uint32_t x, uint32_t y);
    uint32_t smatrix_set(smatrix_t* self, uint32_t x, uint32_t y, uint32_t value);
    uint32_t smatrix_incr(smatrix_t* self, uint32_t x, uint32_t y, uint32_t value);
    uint32_t smatrix_decr(smatrix_t* self, uint32_t x, uint32_t y, uint32_t value);

Get a whole "row" of the matrix by row coordinate x. _All of the methods are threadsafe_

    uint32_t smatrix_rowlen(smatrix_t* self, uint32_t x);
    uint32_t smatrix_getrow(smatrix_t* self, uint32_t x, uint32_t* ret, size_t ret_len);


Java / Scala API
----------------

here be dragons


Ruby API
--------

here be dragons


Benchmarks
----------

**No big-data disclaimer:** We are using this code to run a Collaborative Filtering
recommendation engine for one of Germany's largest ecommerce sites. It is tested on "small-data"
datasets with up to 40GB per matrix (1.5 billion values in 13 million rows). If your data is
actually much bigger (measured in terrabytes, not gigabytes) this library is not for you.

here be dragons


Examples
-------

+ There is a simple example in src/smatrix_example.c
+ There is a simple Collaborative Filtering based recommendation engine in src/smatrix_example_recommender.c


License
-------

Copyright (c) 2011 Paul Asmuth

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy and modify copies of the Software, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
