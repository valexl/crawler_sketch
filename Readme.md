
# Crawler sketch

## Instalation

You need Elasticsearch installed globally:

```sh
$ brew install elasticsearch
```

You need clone application :

```sh
$ cd workspace #directory where will be current project
$ git clone https://github.com/valexl/crawler_sketch.git 
$ cd crawler_sketch
```

You need make bundle install before:

```sh
$ bundle install
```

Test that everything is well:

```sh
$ rspec spec
```

Try it in irb:

```sh
$ irb -r ./boot.rb
```

### Ideas

    1) We have to create available industries list
    
    2) We have to have implements for detecting new industries (for the first time we can use some constant list. For example http://hbswk.hbs.edu/industries/)
    
    3) We have to have implements for detecting industry for the current page
        3.1 Try to find words from industry in title or page description field
        3.2 Try to use machine learning for detecting industry by title or description
        3.3 If the industry is nil then mark this url as unprocessable at the moment
        3.4 After some time this url will be run again by this algorithm (when machine learn increase its knowledge)
    
    
    
