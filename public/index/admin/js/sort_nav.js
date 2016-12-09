window.onload = function() {
	var nclass=$(".topmenu");
	
	var Lis = nclass.find("li");
	Lis.prop("tagname");
	for(i = 0; i < Lis.length; i++) {
		Lis[i].i = i;
		Lis[i].onmouseover = function() {
			this.className = "lihover";
//
//			var h0 = (this.i - 1) * 30 + 82;
//			var y = this.getElementsByTagName("div")[0].offsetHeight;
//			var h = this.getElementsByTagName("div")[0].style.top + y;
//
//			if(h < h0) {
//				this.getElementsByTagName("div")[0].style.top = h0 + "px";
//			}
//
//			if(y > 550) {
//				this.getElementsByTagName("div")[0].style.top = "3px";
//			}
		}

		Lis[i].onmouseout = function() {
			this.className = "";
		}
	}

}