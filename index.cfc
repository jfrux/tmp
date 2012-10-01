component extends="foundry.core" {
  /**
  * Module dependencies.
  */
  variables.fs = require('fs');
  variables.path = require('path');
  variables.process = require('process');
  variables.exists = fs.exists;
  variabiles._ = require("util");

  // store the actual TMP directory
  variables._TMP = _getTMPDir();

    // the random characters to choose from
  variables.randomChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
  variables.randomCharsLength = len(randomChars);

    // this will hold the objects need to be removed on exit
  variables._removeObjects = [];

  public any function dir() {
    return _createTmpDir(argumentCollection=arguments);
  }

  /**
  * Gets the temp directory.
  *
  * @return {String}
  * @api private
  */
  private any function  _getTMPDir() {
    var tmpNames = [ 'TMPDIR', 'TMP', 'TEMP' ];
    length = arrayLen(tmpNames);

    for (var i = 1; i < length; i++) {
      if (len(trim(process.env(tmpNames[i]))) EQ 0) continue;
      console.log(process.env(tmpNames[i]));
      return process.env(tmpNames[i]);
    }

    // fallback to the default
    return '/tmp';
  };

  // /**
  // * Checks whether the `obj` parameter is defined or not.
  // *
  // * @param {Object} obj
  // * @return {Boolean}
  // * @api private
  // */
  // function _isUndefined(obj) {
  //   return typeof obj === 'undefined';
  // };

  /**
  * Parses the function arguments.
  *
  * This function helps to have optional arguments.
  *
  * @param {Object} options
  * @param {Function} callback
  * @api private
  */
  private any function  _parseArguments(options, callback) {
    if (!structKeyExists(arguments,'callback') || !_.isFunction(callback)) {
      callback = options;
      options = {};
    }

    return [ options, callback ];
  };

  /**
  * Gets a temporary file name.
  *
  * @param {Object} opts
  * @param {Function} cb
  * @api private
  */
  private any function _getTmpName(options, callback) {
    var args = _parseArguments(options, callback);
     var  opts = args[1];
     var  cb = args[2];
     var  templateDefined = (structKeyExists(opts,'template'));
     var  template = (templateDefined)? new RegExp(opts.template) : "";
     var  tries = structKeyExists(opts,'tries')? opts.tries : 3;
    if (!isNumeric(tries) || tries < 0)
      return cb('Invalid tries');

    if (templateDefined && !template.match("XXXXXX")) { 
    
      return cb('Invalid template provided');
    }

    var _getName = function() {

      // prefix and postfix
      if (!templateDefined) {
        var name = arrayToList([
          (!structKeyExists(opts,'prefix')) ? 'tmp-' : opts.prefix,
          (createUUID()),
          (!structKeyExists(opts,'postfix')) ? '' : opts.postfix,
        ],'');
        var dir = structKeyExists(opts,'dir')? opts.dir : variables._TMP;

        return path.join(dir, name);
      }

      // mkstemps like template
      var chars = [];

      for (var i = 0; i < 6; i++) {
        chars.add(
          randomChars.substr(Math.floor(Math.random() * randomCharsLength), 1));
      }

      return replace(template,XXXXXX,arrayToList(chars.join,''));
    };

    _getUniqueName = function() {

      var name = _getName();
      
      // check whether the path exists then retry if needed
      fs.exists(name, function(pathExists) {
        if (pathExists) {
          if (tries-- > 0) return _getUniqueName();

          return cb('Could not get a unique tmp filename, max tries reached');
        };
        cb({}, name);
      });
    };

    _getUniqueName();

    return true;
  };

  // /**
  // * Creates and opens a temporary file.
  // *
  // * @param {Object} options
  // * @param {Function} callback
  // * @api public
  // */
  // function _createTmpFile(options, callback) {
  //   var
  //     args = _parseArguments(options, callback),
  //     opts = args[0],
  //     cb = args[1];

  //     opts.postfix = (_isUndefined(opts.postfix)) ? '.tmp' : opts.postfix;

  //   // gets a temporary filename
  //   _getTmpName(opts, function _tmpNameCreated(err, name) {
  //     if (err) return cb(err);

  //     // create and open the file
  //     fs.open(name, _c.O_CREAT | _c.O_EXCL | _c.O_RDWR, opts.mode || 0600, function _fileCreated(err, fd) {
  //       if (err) return cb(err);

  //       if (!opts.keep) _removeObjects.push([ fs.unlinkSync, name ]);

  //       cb(null, name, fd);
  //     });
  //   });
  // };

  /**
  * Creates a temporary directory.
  *
  * @param {Object} options
  * @param {Function} callback
  * @api public
  */
  public any function _createTmpDir(options, callback) {
    var args = _parseArguments(argumentCollection=arguments);
    var opts = args[1];
    var cb = args[2];

    // gets a temporary filename
    _getTmpName(opts, function(err, name) {
      if (structKeyExists(arguments,'err') AND structCount(arguments.err) GT 0) return cb(err);

      // create the directory
      fs.mkdir(name, 0700, function(err) { 
        if (structKeyExists(arguments,'err') and structCount(arguments.err) GT 0) return cb(err);

        if (!structKeyExists(opts,'keep')) _removeObjects.add([ fs.rmdirSync, name ]);

        cb('', name);
      });
    });
  };

  // /**
  // * The garbage collector.
  // *
  // * @api private
  // */
  // function _garbageCollector() {
  //   for (var i = 0, length = _removeObjects.length; i < length; i++) {
  //     try {
  //       _removeObjects[i][0].call(null, _removeObjects[i][1]);
  //     } catch (e) {
  //       // already removed?
  //     }
  //   };
  // };

  // adding to the exit listener
  //process.addListener('exit', _garbageCollector);

}