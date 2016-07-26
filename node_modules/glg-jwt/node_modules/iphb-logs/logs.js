/**
 * Simple API for logging that gives a central place to control logging behavior
 */

// Yoink in console colors (we use colors/safe so no overrides)
var colors = require('colors/safe');

// Set the colors for various log levels
colors.setTheme({
  input: 'grey',
  verbose: 'cyan',
  prompt: 'grey',
  info: 'green',
  data: 'blue',
  help: 'cyan',
  warn: 'yellow',
  debug: 'white',
  success: 'green',
  fail: 'red',
  error: 'red'
});

/**
 * Main export object
 * @type {Object}
 */
var log = {

  /**
   * Settings
   * @type {Object}
   */
  enable: {
    logging: true,
    debug: false,
    verbose: false,
    warn: true,
    tests: false,
    input: true,
    info: true,
    data: true,
    error: true
  },
  /**
   * @function sanitizeArgs
   * @abstract Used for general formatting and color application of the log
   *           output
   * @param  {object} originalArguments The special 'argument' object from
   *                                    the original call to the log functions
   * @param  {string} color             The color to the log output
   * @param  {string} label             The label to prefix to this log output
   * @return {array}                    Cleaned up log output
   */
  sanitizeArgs: function(originalArguments, color, label) {
    var args = Array.prototype.slice.call(originalArguments);
    args.unshift(label);
    var c = args.length;
    while (c--) {
      if (typeof(args[c]) === "object") {
        args[c] = "\n" + JSON.stringify(args[c], null, 2);
      }
      args[c] = color(args[c]);
    }
    return args;
  },
  /**
   * @function debug
   * @abstract Debug Log Output
   */
  debug: function() {
    if (!this.enable.debug || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.debug, '[Debug]  '));
  },
  /**
   * @function error
   * @abstract Error Log Output
   */
  error: function() {
    if (!this.enable.error || !this.enable.logging) {
      return;
    }
    console.error.apply(console, this.sanitizeArgs(arguments, colors.error, '[Error]  '));
  },
  /**
   * @function warn
   * @abstract Warn Log Output
   */
  warn: function() {
    if (!this.enable.warn || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.warn, '[Warn]   '));
  },
  /**
   * @function input
   * @abstract Input Log Output
   */
  input: function() {
    if (!this.enable.input || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.input, '[Input]  '));
  },
  /**
   * @function verbose
   * @abstract Verbose Log Output
   */
  verbose: function() {
    if (!this.enable.verbose || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.verbose, '[Verbose]'));
  },
  /**
   * @function info
   * @abstract Info Log Output
   */
  info: function() {
    if (!this.enable.info || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.info, '[Info]   '));
  },
  /**
   * @function info
   * @abstract Info Log Output
   */
  success: function() {
    if (!this.enable.tests) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.success, '[Success]'));
  },
  /**
   * @function info
   * @abstract Info Log Output
   */
  fail: function() {
    if (!this.enable.tests) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.fail, '[Fail]   '));
  },
  /**
   * @function data
   * @abstract Data Log Output
   */
  data: function() {
    if (!this.enable.data || !this.enable.logging) {
      return;
    }
    console.log.apply(console, this.sanitizeArgs(arguments, colors.data, '[Data]   '));
  }
};

// Expose the log functions
module.exports = log;
