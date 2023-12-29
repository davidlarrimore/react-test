# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/CHANGELOG.md for
# a list of version numbers.
#FROM phusion/passenger-full:<VERSION>
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby30:<VERSION>
#FROM phusion/passenger-ruby31:<VERSION>
#FROM phusion/passenger-ruby32:<VERSION>
#FROM phusion/passenger-jruby93:<VERSION>
#FROM phusion/passenger-jruby94:<VERSION>
FROM phusion/passenger-nodejs:latest
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Node.js and Meteor standalone support (not needed if you will also be installing Ruby, unless you need a version other than the default)
#RUN /pd_build/nodejs.sh 18
#
#   Ruby support
#RUN /pd_build/ruby-3.0.*.sh
#RUN /pd_build/ruby-3.1.*.sh
#RUN /pd_build/ruby-3.2.*.sh
#RUN /pd_build/jruby-9.3.*.sh
#RUN /pd_build/jruby-9.4.*.sh
#
#   Python support
#RUN /pd_build/python.sh 3.10

# ...put your own build instructions here...

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# add app
COPY . ./
# start app
CMD ["npm", "start"]    


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
