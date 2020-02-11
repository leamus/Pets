.pragma library

function random(n1,n2) {
    if(n1 == n2)
        return n1;
    else if(n2 < n1)
    {
        n1=n1+n2;
        n2=n1-n2;
        n1=n1-n2;
    }
    return n1 + Math.round((n2-n1) * Math.random());
}

function randTarget(n, m) {		//	m分之n
    if(n > m || n < 0)return -1;	//不符合
    if(Math.random() < n / m)return 1;	//命中
    return 0;
}

//使用hash
function GetDifferentNumber(n1, n2, n) {
    if(Math.abs(n2 - n1) < n)
        return false;

    var ret = [];
    var hash = new Object;
    var number;
    for(; n > 0;)
    {
        number = random(n1,n2);
        if(!(number in hash)) {
            hash[number] = true;
            ret[n - 1] = number;
            n--;
        }
    }
    return ret;
}






///<summary>获得字符串实际长度，中文2，英文1</summary>
function strlen(str) {
    var l = str.length;
    var blen = 0;
    for(var i = 0; i < l; i++) {
        if ((str.charCodeAt(i) & 0xff00) != 0) {
            blen ++;
        }blen ++;
    }
    return blen;
}

function strlen1(str) {
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128)
            realLength += 1;
        else
            realLength += 2;
    }
    return realLength;
}

function strlen2(str) {
    return str.replace(/[\u0391-\uFFE5]/g,"aa").length;
    //先把中文替换成两个字节的英文，在计算长度
}

function strUnicodeCount(str) {
    var l = str.length;
    var blen = 0;
    for(var i = 0; i < l; i++) {
        if ((str.charCodeAt(i) & 0xff00) != 0) {
            blen ++;
        }
    }
    return blen;
}

function strAscCount(str) {
    var l = str.length;
    var blen = 0;
    for(var i = 0; i < l; i++) {
        if ((str.charCodeAt(i) & 0xff00) == 0) {
            blen ++;
        }
    }
    return blen;
}


//去掉bom头
function removeBom(str) {

    if(str.slice(0,1) === "\uEFBBBF")   //UTF-8
        return str.replace("\uEFBBBF","");
        //return str.slice(3);  //substring(3); //substr(3);
    else if(str.slice(0,1) === "\uFEFF")  //UTF-16/UCS-2, little endian(UTF-16LE)
        return str.replace("\uFEFF","");
    else if(str.slice(0,1) === "\uFFFE")  //UTF-16/UCS-2, big endian(UTF-16BE)
        return str.replace("\uFFFE","");
    else if(str.slice(0,1) === "\uFFFE\x00\x00")  //UTF-32/UCS-4, little endian.
        return str.replace("\uFFFE0000","");
    else if(str.slice(0,1) === "\u0000FEFF")  //UTF-32/UCS-4, big-endia
        return str.replace("\u0000FEFF","");

    return str;

}

//检测是否为Json字符串
function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if (typeof obj == "object" && obj) {
                return true;
            }
            else
                return false;
        }
        catch(e) {
            console.log('error:', e);
            return false;
        }
    }
    console.log('It is not a string!');
}


function deepCopyObject(obj) {

    // Handle the 3 simple types, and null or undefined
    if (null === obj || "object" != typeof obj) return obj;
    if(!(obj instanceof Object) || "function" === typeof obj) return obj;

    var copy;

    // Handle Array
    if (obj instanceof Array) {
      copy = [];
      /*var len = obj.length;
      for (var i = 0; i < len; ++i) {
        copy[i] = clone(obj[i]);
      }
      return copy;*/
    }

    // Handle Object
    else if (obj instanceof Object) {
      copy = {};
      /*for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
      }
      return copy;*/
    }

    for(var attr in obj) {
        //基本数据类型和函数
        if(!(attr instanceof Object) || typeof attr === 'function')
            copy[attr] = obj[attr];
        else
            copy[attr] = clone(obj[attr]);
    }
    return copy;

    //throw new Error("Unable to copy obj! Its type isn't supported.");

}

function deepCopyObject1(obj) {

    // Handle the 3 simple types, and null or undefined
    if (null === obj || "object" != typeof obj) return obj;
    if(!(obj instanceof Object) || "function" === typeof obj) return obj;

    var copy;
    // Handle Date
    if (obj instanceof Date) {
      copy = new Date();
      copy.setTime(obj.getTime());
      return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
      copy = [];
      var len = obj.length;
      for (var i = 0; i < len; ++i) {
        copy[i] = clone(obj[i]);
      }
      return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
      copy = {};
      for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
      }
      return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");

}

function deepCopyObject2(obj) {
    return JSON.parse(JSON.stringify(obj));
}
