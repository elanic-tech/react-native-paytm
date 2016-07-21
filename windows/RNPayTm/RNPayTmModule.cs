
using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNPayTm
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNPayTmModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNPayTmModule"/>.
        /// </summary>
        internal RNPayTmModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNPayTm";
            }
        }
    }
}
