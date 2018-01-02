/**
 * Native为H5提供的Api接口
 *
 * @type {js对象}
 */
var JSObject = (function() {

	var NativeApi = {
        share: function(param) {
            //调用native端
            _nativeShare(param);
        },
	}
    function _nativeShare(param) {
        //js -> oc
        window.webkit.messageHandlers.shareTitle.postMessage(param);
    }

    //闭包，把Api对象返回
	return NativeApi;
})();

