<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalMealList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🍱 식단 목표 목록</h2>
			<p class="text-muted">당신이 설정한 마법의 식단 목표를 확인해보세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty nutritionGoalList}">
		<div class="alert alert-info text-center">아직 등록된 식단 목표가 없습니다.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/goalInputNutrition" class="btn btn-outline-primary">+목표 설정</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️수정모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌수정취소</button>
	</div>

	<c:if test="${not empty nutritionGoalList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x:auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 700px;">
				<thead>
					<tr class="bg-light">
						<th>no.</th>
						<th style="min-width:120px;">목표 유형</th>
						<th style="min-width:140px;">목표 항목</th>
						<th style="min-width:160px;">목표 수치</th>
						<th style="min-width:140px;">기간</th>
						<th style="min-width:100px;">설정자</th>
						<th style="min-width:120px;">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${nutritionGoalList}" varStatus="st">
						<tr data-index="${status.index}" data-expired="${vo.expired}">
							<td>${st.count}</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">영양소</c:when>
									<c:when test="${vo.goal_type == 2}">식품</c:when>
									<c:otherwise>알 수 없음</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">
										${vo.nutrient_name}
									</c:when>
									<c:otherwise>
										${vo.food_name}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<fmt:formatNumber value="${vo.target_value}" maxFractionDigits="2" />
								${vo.goal_unit_label}
							</td>
							<td>
								<fmt:formatDate value="${vo.start_date}" pattern="yyyy-MM-dd" /> ~
								<fmt:formatDate value="${vo.end_date}" pattern="yyyy-MM-dd" />
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.set_by == 1}">🙋‍♂️ 본인</c:when>
									<c:otherwise>🧙 전문가</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.expired}">
										<span class="text-muted">종료됨</span>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-primary" onclick="editGoal(${vo.goal_id})">수정</button>
									</c:otherwise>
								</c:choose>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleGoalDelete(${vo.goal_id});">삭제</a>
								<input type="hidden" name="goal_id" value="${vo.goal_id}" />
								<input type="hidden" class="goalType" value="${vo.goal_type}" />
								<input type="hidden" class="itemName" value="${vo.goal_type == 1 ? vo.nutrient_name : vo.food_name}" />
								<input type="hidden" class="goalUnitCode" value="${vo.goal_unit}" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:if>

	<div class="mt-4 text-center">
		<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
	</div>
</main>

<script type="text/javascript">
    const ctp = "${ctp}";
    let isEditMode = false, editBtn, cancelBtn, selectAllBtn;

    /* JSTL → JS 데이터 */
    const nutrientArr = [
        <c:forEach var="n" items="${nutrientList}">
            {id:${n.id},name:"${n.name}",unit:"${n.unit}",goalUnit:${n.goalUnitCode}},
        </c:forEach>];
    const foodArr = [
        <c:forEach var="f" items="${foodList}">
            {id:${f.food_id},name:"${f.name}"},
        </c:forEach>];
    const unitArr = [
        <c:forEach var="u" items="${unitList}">
            {code:${u.code},label:"${u.label}",isInt:${u.integerOnly},goalType:${u.goalType}},
        </c:forEach>];

    /* 단일 삭제 */
    function confirmSingleGoalDelete(goalId){
        const box = document.querySelector("#wizard-delete-confirm");
        box.classList.remove("d-none");
        document.getElementById("wizard-confirm-yes").onclick = function(){
            box.classList.add("d-none");
            location.href = ctp + "/rec/goalDeleteNutrition?goal_id=" + goalId;
        };
        document.getElementById("wizard-confirm-no").onclick = function(){
            box.classList.add("d-none");
        };
    }

    // 수정 모드
    document.addEventListener("DOMContentLoaded", function(){
        editBtn   = document.getElementById("toggleEditModeBtn");
        cancelBtn = document.getElementById("cancelEditModeBtn");
        const table = document.querySelector("table");
        if(!editBtn || !cancelBtn || !table) return;

        /* 전체 선택 버튼 동적 생성 */
        const toggleSelectAllBtn = document.createElement("button");
        toggleSelectAllBtn.id = "toggleSelectAllBtn";
        toggleSelectAllBtn.className = "btn btn-outline-dark me-1 d-none";
        toggleSelectAllBtn.textContent = "✔️전체선택";
        editBtn.parentNode.insertBefore(toggleSelectAllBtn, editBtn);
        selectAllBtn = toggleSelectAllBtn;

        /* 수정모드 토글 */
       /*  editBtn.addEventListener("click", function(){
            if(isEditMode){
                if(!submitGoalMultiUpdate()) return;
            }else{
                enterEditMode();
            }
        }); */
        
     	// 수정모드 토글 및 분기 처리
	     editBtn.addEventListener("click", function(){
	         if(isEditMode){
	             // 삭제 대상이 있는지 우선 확인
	             const anySelected = [...document.querySelectorAll("tbody tr")]
	                                  .some(r=>r.classList.contains("table-success"));
	             if(anySelected){
	                 if(!submitGoalMultiDelete()) return;  // 다중 삭제
	             } else {
	                 if(!submitGoalMultiUpdate()) return;  // 다중 수정
	             }
	         } else {
	             enterEditMode();
	         }
	     });

        cancelBtn.addEventListener("click", function(){
            toggleSelectAllBtn.classList.add("d-none");
            location.reload();
        });

        toggleSelectAllBtn.addEventListener("click", function(){
            const rows = document.querySelectorAll("tbody tr");
            const deselect = [...rows].some(r => r.classList.contains("table-success"));
            rows.forEach(r=>{
                if(deselect){
                    r.classList.remove("table-success");
                    r.removeAttribute("data-selected");
                }else{
                    r.classList.add("table-success");
                    r.setAttribute("data-selected","true");
                }
            });
            selectAllBtn.textContent = deselect ? "✔️전체선택" : "❌선택해제";
            updateGoalEditButtonLabel();
        });

        /* ---------- 내부 함수 ---------- */
        function enterEditMode(){
            isEditMode = true;
            editBtn.textContent = "✅적용하기";
            cancelBtn.classList.remove("d-none");
            selectAllBtn.classList.remove("d-none");

            const rows = table.querySelectorAll("tbody tr");
            rows.forEach(function(row, idx){
                row.dataset.index = idx;
                buildEditableRow(row);
            });
        }

        function buildEditableRow(row){
        	    const isExpired = row.getAttribute("data-expired") === "true";

        	    const goalId = row.querySelector("input[name='goal_id']").value;
        	    const goalType = row.querySelector(".goalType").value;
        	    const itemName = row.querySelector(".itemName").value;
        	    const goalUnitCode = row.querySelector(".goalUnitCode").value;

        	    const cells = row.querySelectorAll("td");
        	    const typeCell  = cells[1];
        	    const itemCell  = cells[2];
        	    const valueCell = cells[3];
        	    const dateCell  = cells[4];
        	    const ctrlCell  = cells[6];

        	    /* 목표 유형 select */
        	    typeCell.innerHTML =
        	        "<select name='goal_type' class='form-select form-select-sm'" +
        	        (isExpired ? " disabled" : "") + ">" +
        	        "<option value='1'" + (goalType==="1"?" selected":"") + ">영양소</option>" +
        	        "<option value='2'" + (goalType==="2"?" selected":"") + ">식품</option>" +
        	        "</select>";

        	    /* 목표 수치 + 단위 */
        	    const vNum = parseFloat(valueCell.textContent.trim().replace(/[^\d.]/g,""));
        	    valueCell.innerHTML =
        	        "<div class='input-group'>" +
        	            "<input type='number' name='target_value' class='form-control form-control-sm' step='0.1' value='"+vNum+"' required" +
        	            (isExpired ? " disabled" : "") + "/>" +
        	            "<select name='goal_unit' class='form-select form-select-sm' required" +
        	            (isExpired ? " disabled" : "") + "></select>" +
        	        "</div>";

        	    const goalUnitSel = valueCell.querySelector("select[name='goal_unit']");
        	    renderItemCell(itemCell, goalType, itemName, goalUnitSel);
        	    renderGoalUnit(goalUnitSel, goalUnitCode, goalType);

        	    typeCell.querySelector("select[name='goal_type']").addEventListener("change", function(){
        	        const newType = this.value;
        	        renderItemCell(itemCell, newType, "", goalUnitSel);
        	        if(newType==="1"){
        	            const nId = parseInt(itemCell.querySelector("select").value);
        	            const unit = (nutrientArr.find(n=>n.id===nId)||{}).goalUnit;
        	            renderGoalUnit(goalUnitSel, unit, "single");
        	        }else{
        	            renderGoalUnit(goalUnitSel, null, "multi");
        	        }
        	    });

        	    /* 기간 */
        	    const dates = dateCell.textContent.trim().split("~");
        	    const s = dates[0].trim(), e = dates[1].trim();
        	    dateCell.innerHTML =
        	        "<input type='date' name='start_date' class='form-control form-control-sm mb-1' value='"+s+"' readonly/>" +
        	        "<input type='date' name='end_date' class='form-control form-control-sm' value='"+e+"' required" +
        	        (isExpired ? " disabled" : "") + "/>";

        	    /* 제어 셀 */
        	    ctrlCell.innerHTML =
        	        "<input type='hidden' name='goal_id' value='"+goalId+"'/>" +
        	        (isExpired
        	            ? "<span class='text-muted'>수정불가</span>"
        	            : "<button class='btn btn-sm btn-outline-success' onclick='submitSingleGoalEdit(this)'>개별저장</button>");

        	    /* 변경 감지 */
        	    row.querySelectorAll("input,select").forEach(function(el){
        	        el.addEventListener("change", function(){
        	            markRowChanged(row);
        	        });
        	    });

        	    /* 행 선택 토글 */
        	    row.addEventListener("click", function(e){
        	        if(e.target.closest("button")||e.target.tagName==="A") return;
        	        row.classList.toggle("table-success");
        	        row.dataset.selected = row.classList.contains("table-success");
        	        updateGoalEditButtonLabel();
        	    });
        	}

        function markRowChanged(row){
            if(row.dataset.changed!=="true"){
                row.dataset.changed = "true";
                const hidden = createHidden("goalList["+row.dataset.index+"].changed","true");
                row.appendChild(hidden);
            }
            updateGoalEditButtonLabel();
        }

        /* 다중 저장 */
        function submitGoalMultiUpdate(){
            const changedRows = [...document.querySelectorAll("tbody tr")].filter(r=>r.dataset.changed==="true");
            if(changedRows.length===0){
                showWizardMessage("수정할 목표가 없어요! 행을 선택하거나 내용을 바꿔주세요.");
                return false;
            }

            const form = document.createElement("form");
            form.method = "post";
            form.action = ctp + "/rec/goalMultiUpdateNutrition";

            let idx = 0, valid = true;
            changedRows.forEach(function(row){
                if(!validateFormOnSubmit(row)){ valid=false; return; }
                ["goal_id","goal_type","nutrient_id","food_id",
                 "target_value","goal_unit","start_date","end_date"].forEach(function(nm){
                    const el = row.querySelector("[name='"+nm+"']");
                    if(el) form.appendChild(createHidden("goalList["+idx+"]."+nm, el.value));
                });
                form.appendChild(createHidden("goalList["+idx+"].changed","true"));
                idx++;
            });

            if(!valid) return false;
            document.body.appendChild(form); form.submit();
            return true;
        }

    }); /* DOMContentLoaded 끝 */

    /* ---------------- 공통 유틸 ---------------- */
    function updateGoalEditButtonLabel(){
        const rows = document.querySelectorAll("tbody tr");
        let selected = 0, changed = 0;
        rows.forEach(function(r){
            if(r.classList.contains("table-success")) selected++;
            if(r.dataset.changed==="true") changed++;
        });
        /* if(editBtn){
            editBtn.textContent = changed>0 ? "✅적용하기" : "✏️수정모드";
        } */
        if (editBtn) {
            if (selected > 0) editBtn.textContent = "🗑️선택삭제";
            else editBtn.textContent = changed > 0 ? "✅적용하기" : "✏️수정모드";
        }
        if(selectAllBtn){
            selectAllBtn.textContent = selected>0 ? "❌선택해제" : "✔️전체선택";
        }
    }

    function renderGoalUnit(sel, code, mode){
        sel.innerHTML = "";
        if(mode==="single"){
            const meta = unitArr.find(u=>u.code==code);
            if(meta){
                const o = document.createElement("option");
                o.value = meta.code; o.textContent = meta.label; o.selected = true;
                sel.appendChild(o);
            }
        }else{
            unitArr.filter(u=>u.goalType==2).forEach(function(u){
                const o = document.createElement("option");
                o.value = u.code; o.textContent = u.label;
                if(u.code==code) o.selected = true;
                sel.appendChild(o);
            });
        }
    }

    function renderItemCell(cell, typeVal, selectedName, unitSel){
        const sel = document.createElement("select");
        sel.name = typeVal==="1" ? "nutrient_id" : "food_id";
        sel.className = "form-select form-select-sm";
        const arr = typeVal==="1" ? nutrientArr : foodArr;
        arr.forEach(function(o){
            const opt = document.createElement("option");
            opt.value = o.id; opt.textContent = o.name;
            if(o.name===selectedName) opt.selected = true;
            sel.appendChild(opt);
        });
        cell.innerHTML = ""; cell.appendChild(sel);

        if(typeVal==="1" && unitSel){
            function setUnit(id){
                const nt = nutrientArr.find(n=>n.id===parseInt(id))||{};
                renderGoalUnit(unitSel, nt.goalUnit, "single");
            }
            setUnit(sel.value);
            sel.addEventListener("change", function(){ setUnit(this.value); });
        }
    }

    function createHidden(nm, val){
        const i = document.createElement("input");
        i.type = "hidden"; i.name = nm; i.value = val; return i;
    }

    /* 단건 저장 */
    function submitSingleGoalEdit(btn){
        const row = btn.closest("tr");
        if(!validateFormOnSubmit(row)) return;
        const form = document.createElement("form");
        form.method = "post";
        form.action = ctp + "/rec/goalUpdateNutrition";
        ["goal_id","goal_type","target_value","goal_unit",
         "start_date","end_date","nutrient_id","food_id"].forEach(function(nm){
            const el = row.querySelector("[name='"+nm+"']");
            if(el) form.appendChild(createHidden(nm, el.value));
        });
        document.body.appendChild(form); form.submit();
    }
    
    /* 다중 삭제 */
    function submitGoalMultiDelete(){
    	  const selectedRows = [...document.querySelectorAll("tbody tr")]
    	    .filter(r=>r.classList.contains("table-success"));
    	  if(selectedRows.length===0){
    	    showWizardMessage("삭제할 목표를 선택하세요.");
    	    return false;
    	  }
    	  const form = document.createElement("form");
    	  form.method = "post";
    	  form.action = ctp + "/rec/goalMultiDeleteNutrition";
    	  selectedRows.forEach((row,idx)=>{
    	    const id = row.querySelector("input[name='goal_id']").value;
    	    form.appendChild(createHidden("goalList["+idx+"].goal_id", id));
    	  });
    	  document.body.appendChild(form);
    	  form.submit();
    	  return true;
    	}

</script>


<jsp:include page="/WEB-INF/views/include/footer.jsp" />
