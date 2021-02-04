<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.spring.gogidang.domain.*"%>

<%@include file="../includes/header_simple.jsp"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal.css"
	type="text/css">
	
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/store_reviewStyle.css"
	type="text/css">

<!-- Product Section Begin -->
<section class="product spad">
	<div class="container">
		<div class="row">
			<div class="col-lg-3 col-md-5">
				<div class="sidebar">
					<div class="sidebar__item">
						<h4>관리자 페이지</h4>
						<ul>
							<li><a href="storeWait.st">대기중인 가게 승인</a></li>
							<li><a href="noticeAdmin.no">공지사항 관리</a></li>
							<li><a href="qnaAdmin.qn">문의 관리</a></li>
							<li><a href="eventAdmin.ev">이벤트 관리</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="qnaboard">
				<div class="section-title product__discount__title">
					<h2>문의 관리</h2>
				</div>
				<div class="container">
					<table class="table table-hover">
						<thead>
							<tr align=center>
								<th>번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>등록일</th>
								<th>답변 상태</th>
							</tr>
						</thead>
						<tbody id="qna_content" class="text-center">
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</section>


<!-- The Modal -->
<div id="myModal" class="modal">
	<!-- Modal content -->
	<div class="modal-content">
		<span class="close">&times;</span>                                                               
		<form name="qnaForm">
			<fieldset>
			<legend>문의 내용</legend>
			<ol>
			  <li>
			    <label for="qna_num">문의번호</label>
			    <input type="text" id="qna_num" name="qna_num" readonly>
			  </li>
				<li>
			    <label for="title">문의제목</label>
			    <input type="text" id="title" name="title" readonly />
			  </li>
			  <li>
			    <label for="u_id">회원아이디</label>
			    <input type="text" id="u_id" name="u_id" readonly>
			  </li>
				<li>
				<label for="content">리뷰내용</label>
			    <input id="content" name="content" type="text" readonly>
			  </li> 
				<li>
					<label for="re_content">답글</label>
			   <input type="text" id="re_content" name="re_content"/>
			  </li> 
			</ol>
			</fieldset>

			<fieldset>
			  	<input type="button" id="reQnaWrite" name="reQnaWrite" value="댓글달기"/>
			  	<input type="button" id="" value="닫기"/>
			</fieldset>
		</form>
	</div>
</div>
<!-- modal END -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

<script>

// Get the modal
var modal = document.getElementById('myModal');

// Get the button that opens the modal
var btn = document.getElementById('myBtn');

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];  

$(document).ready(function() {
	
	qnaList();
});

function qnaList(){
	  $.ajax({
	     url : 'qnaListAjax.re',
	     contentType : 'application/x-www-form-urlencoded; charset=utf-8',
	     success : function(data){ 
	        var a ='';
	        $.each(data, function(key,value){ //data는 list객체를 받음(controller return 부분)list는 commentVO를 여려개 가지고 있음
	      		a += '<tr align=center><td>'+ value.qna_num + '</td>';
	      		a += '<td>' + value.title + '</td>';
	      		a += '<td>' + value.u_id + '</td>';
	      		a += '<td>' + value.re_date + '</td>';
	      		if (value.re_content != null) {
	      			a += '<td><h6>답변완료</h6></td>';
	      		} else {
		      		a += '<td><button onclick="callModal(' + value.qna_num + ');" id="myBtn" class="btn btn-primary btn-xs pull-right">문의댓글</button></td></tr>';
	      		}
	        });
	        
	        $("#qna_content").html(a); //a내용을 html에 형식으로 .commentList로 넣음
	     },
	     error:function(){
	        alert("ajax통신 실패(list)!!!");
	     }
	  });
	}
	
function callModal(event) {
	$.ajax({
		url : 'qnaInfoAjax.re',
		type : 'POST',
		data : {'qna_num' : event},
		contentType : 'application/x-www-form-urlencoded;charset=utf-8',
		dataType : 'json',
		success : function(retVal) {
			if (retVal.res == "OK") {
				var qna_num = retVal.qna_num;
				var u_id = retVal.u_id;
				var title = retVal.title;
				var content = retVal.content;
				$('input#qna_num').val(qna_num);
				$('input#u_id').val(u_id);
				$('input#title').val(title);
				$('input#content').val(content);
			} else {
				alert("qna modal Fail!!!!");
			}
		}
	});
	
    modal.style.display = "block";
}

$('[name=reQnaWrite]').click(function () {
	var insertData = $('[name=qnaForm]').serialize();
	alert(insertData);
	reQnaInsert(insertData);
});

function reQnaInsert(insertData) {
	$.ajax({
		url : 'reQna.qn',
		type : 'POST',
		data : insertData,
		success : function(data) {
			if (data == 1) {
				noticeList();
			} else {
				alert("qnaRe insert Fail!!!!");
			}
		}
	});
}


// When the user clicks on <span> (x), close the modal
span.onclick = function(event) {
	modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
	if (event.target == modal) {
		modal.style.display = "none";
	}
}
</script>

<%@include file="../includes/footer.jsp"%>