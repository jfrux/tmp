component extends="foundry.core" {
  /**
  * Module dependencies.
  */
  variables.fs = require('fs');
  variables.path = require('path');
  variables.process = require('process');
  variables.exists = fs.exists;

  // store the actual TMP directory
  variables._TMP = _getTMPDir();

    // the random characters to choose from
  variables.randomChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
  variables.randomCharsLength = randomChars.length;

    // this will hold the objects need to be removed on exit
  variables._removeObjects = [];

  /**
  * Gets the temp directory.
  *
  * @return {String}
  * @api private
  */
  function _getTMPDir() {
    var tmpNames = [ 'TMPDIR', 'TMP', 'TEMP' ];
    length = arrayLen(tmpNames);

    for (var i = 0; i < length; i++) {
      if (process.env(tmpNames[i]])) continue;

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

  // /**
  // * Parses the function arguments.
  // *
  // * This function helps to have optional arguments.
  // *
  // * @param {Object} options
  // * @param {Function} callback
  // * @api private
  // */
  // function _parseArguments(options, callback) {
  //   if (!callback || typeof callback != "function") {
  //     callback = options;
  //     options = {};
  //   }

  //   return [ options, callback ];
  // };

  // /**
  // * Gets a temporary file name.
  // *
  // * @param {Object} opts
  // * @param {Function} cb
  // * @api private
  // */
  // function _getTmpName(options, callback) {
  //   var
  //     args = _parseArguments(options, callback),
  //     opts = args[0],
  //     cb = args[1],
  //     template = opts.template,
  //     templateDefined = !_isUndefined(template),
  //     tries = opts.tries || 3;

  //   if (isNaN(tries) || tries < 0)
  //     return cb(new Error('Invalid tries'));

  //   if (templateDefined && !template.match(/XXXXXX/))
  //     return cb(new Error('Invalid template provided'));

  //   function _getName() {

  //     // prefix and postfix
  //     if (!templateDefined) {
  //       var name = [
  //         (_isUndefined(opts.prefix)) ? 'tmp-' : opts.prefix,
  //         process.pid,
  //         (Math.random() * 0x1000000000).toString(36),
  //         opts.postfix
  //       ].join('');

  //       return path.join(opts.dir || _TMP, name);
  //     }

  //     // mkstemps like template
  //     var chars = [];

  //     for (var i = 0; i < 6; i++) {
  //       chars.push(
  //         randomChars.substr(Math.floor(Math.random() * randomCharsLength), 1));
  //     }

  //     return template.replace(/XXXXXX/, chars.join(''));
  //   };

  //   (function _getUniqueName() {
  //     var name = _getName();

  //     // check whether the path exists then retry if needed
  //     exists(name, function _pathExists(pathExists) {
  //       if (pathExists) {
  //         if (tries-- > 0) return _getUniqueName();

  //         return cb(new Error('Could not get a unique tmp filename, max tries reached'));
  //       }

  //       cb(null, name);
  //     });
  //   }());
  // };

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

  // /**
  // * Creates a temporary directory.
  // *
  // * @param {Object} options
  // * @param {Function} callback
  // * @api public
  // */
  // function _createTmpDir(options, callback) {
  //   var
  //     args = _parseArguments(options, callback),
  //     opts = args[0],
  //     cb = args[1];

  //   // gets a temporary filename
  //   _getTmpName(opts, function _tmpNameCreated(err, name) {
  //     if (err) return cb(err);

  //     // create the directory
  //     fs.mkdir(name, opts.mode || 0700, function _dirCreated(err) {
  //       if (err) return cb(err);

  //       if (!opts.keep) _removeObjects.push([ fs.rmdirSync, name ]);

  //       cb(null, name);
  //     });
  //   });
  // };

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

  // exporting all the needed methods
  this.tmpdir = _TMP;
  this.dir = _createTmpDir;
  this.file = _createTmpFile;
  this.tmpName = _getTmpName;
}