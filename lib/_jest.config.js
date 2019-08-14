module.exports = {
    "verbose": true,
    "transform": {
      "^.+\\.js$": "babel-jest",
      "^.+\\.(css|scss|less)$": "jest-css-modules"
    },
    "moduleFileExtensions": [
      "js"
    ],
    "moduleDirectories": [
      "node_modules",
      "src"
    ],
    "moduleNameMapper": {
      "\\.(css|less)$": "<rootDir>/fileMock.js"
    }
  };
