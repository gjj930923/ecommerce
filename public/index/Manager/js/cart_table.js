window.onload = function() {

	var cartTable = document.getElementById('cartTable');
	var tr = cartTable.children[1].rows;
	var checkInputs = document.getElementsByClassName('check');
	var checkAllInputs = document.getElementsByClassName('check-all');
	var selectedTotal = document.getElementById('selectedTotal');
	var priceTotal = document.getElementById('priceTotal');
	var selected = document.getElementById('selected');
	var foot = document.getElementById('cartfoot');
	var selectedViewList = document.getElementById('selectedViewList');
	var deleteAll = document.getElementById('deleteAll');

	//calculate
	function getTotal() {
		
		var seleted = 0;
		var price = 0;
		var HTMLstr = '';
		var cartTable = document.getElementById('cartTable');
		var tr = cartTable.children[1].rows;
		for(var i = 0, len = tr.length; i < len; i++) {
			

				// alert("length"+tr.length);
				tr[i].className = 'on';
				seleted += parseInt(tr[i].getElementsByTagName('input')[1].value);
				price += parseFloat(tr[i].cells[3].innerHTML);
				// alert("price"+price);
				HTMLstr += '<div><img src="' + tr[i].getElementsByTagName('img')[0].src + '"><span class="del" index="' + i + '">取消选择</span></div>'

		}

		selectedTotal.innerHTML = seleted;
		priceTotal.innerHTML = price.toFixed(2);
		selectedViewList.innerHTML = HTMLstr;

		if(seleted == 0) {
			foot.className = 'cartfoot';
		}
	}

	//toal
	function getSubTotal(tr) {

		var tds = tr.parent().parent();

		var price = parseFloat(tds.find(".price").html());

		var count = parseInt(tr.parent().find('.count-input').attr('value'));

		var SubTotal = parseFloat(price * count);
		tds.find('.subtotal').html(SubTotal);
	}

	
		
	

	selected.onclick = function() {
		if(foot.className == 'foot') {
			if(selectedTotal.innerHTML != 0) {
				foot.className = 'foot show';
			}
		} else {
			foot.className = 'foot';
		}
	}

	selectedViewList.onclick = function(e) {
		e = e || window.event;
		var el = e.srcElement;
		if(el.className == 'del') {
			var index = el.getAttribute('index');
			var input = tr[index].getElementsByTagName('input')[0];
			input.checked = false;
			input.onclick();
		}
	}

	//               
	///jQ

	//reduce
	$(document).on('click',"#cartTable tbody tr td .reduce",function() {
		var inputC = $(this).parent().find('.count-input');
		var reduce = $(this).parent().find('.reduce');

		var val = parseInt(inputC.attr('value'));

		if(val > 1) {
			inputC.attr('value', val - 1);
		}
		if(val == 1) {
			// inputC.attr('value', val - 1);
			reduce.html('');
		}
		getSubTotal($(this));
			getTotal();

	});
	//add
	$(document).on('click',"#cartTable tbody tr td .add",function() {
		var inputC = $(this).parent().find('.count-input');
		var val = parseInt(inputC.attr('value'));
		var reduce = $(this).parent().find('.reduce');
		inputC.attr('value', val + 1);
		reduce.html('-');
		getSubTotal($(this));
		getTotal();
	});
	//delete
	$(document).on('click',"#cartTable tbody tr td .delete",function() {
			var conf = confirm('delete Yes？');
			if(conf) {
				$(this).parent().parent().remove();
			}
				getTotal();
	});
	//check all
	$(document).on('click','.check-all ',function(){
//

			$(".checkbox").prop('checked',true);
	});
	$(".fr.closing").click(function(){
		var conf=confirm('check out ?');
		if(conf){
			document.location.href = "index.html";
		}
	});
	checkAllInputs[0].checked = true;
//	checkAllInputs[0].onclick();
}