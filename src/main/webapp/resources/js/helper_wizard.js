const pageType = document.querySelector('main')?.getAttribute('data-page') || 'default';

// 인풋 창이 처음부터 로드되는 경우
document.addEventListener('DOMContentLoaded', function() {
	const inputs = document.querySelectorAll('input, select, textarea');
	const wizard = document.querySelector('#helper_wizard-img');
	const msgBox = document.querySelector('#wizard-message');
	const form = document.querySelector('form');

	// 첫 입력 시 인사 메시지
	let hasWelcomed = false;
	const welcomeMessages = {
		exercise: "마법의 운동 기록을 시작해볼까?",
		exerciseRecordMultiInput: "한꺼번에 마법을 여러 번 시전한다니… 대단해!",
		meal: "오늘 먹은 걸 마법처럼 정리해보자!",
		goal: "작지만 강한 목표가 마법의 시작이야.",
		signup: "너의 이름이 마법에 각인될 거야!",
		default: "마법의 기록을 시작해볼까?"
	};
	inputs.forEach(input => {
		input.addEventListener('focus', () => {
			if (!hasWelcomed) {
				showWizardMessage(welcomeMessages[pageType] || welcomeMessages.default);
				hasWelcomed = true;
			}
		}, { once: true });
	});

	// 마법사 반짝이 효과
	inputs.forEach(input => {
		input.addEventListener('focus', () => {
			wizard.classList.add('wizard-focus-effect');
			setTimeout(() => wizard.classList.remove('wizard-focus-effect'), 300);
		});
	});

	// 모든 필수 입력 완료 메시지
	let hasShownAllFilled = false;
	let allFilledTimer = null;
	function checkAllFieldsFilled() {
		const allFilled = Array.from(inputs).every(el => {
			if (el.required && el.offsetParent !== null) {
				return el.value.trim() !== '';
			}
			return true;
		});
		if (allFilled && !hasShownAllFilled) {
			if (allFilledTimer) return;
			allFilledTimer = setTimeout(() => {
				showWizardMessage("훌륭해! 마법진이 완성됐어!");
				hasShownAllFilled = true;
				allFilledTimer = null;
			}, 1000);
		}
	}
	inputs.forEach(input => {
		input.addEventListener('input', checkAllFieldsFilled);
	});

	// 입력 지연 감지 (30초)
	let wizardIdleTimer;
	function resetWizardIdleTimer() {
		clearTimeout(wizardIdleTimer);
		wizardIdleTimer = setTimeout(() => {
			showWizardMessage("혹시 수면 마법에 걸린 거야?");
		}, 180000);
	}
	inputs.forEach(input => {
		input.addEventListener('input', resetWizardIdleTimer);
	});
	resetWizardIdleTimer();

	// 검증: submit 시에만 실행
	if (form) {
		form.addEventListener('submit', function(e) {
			const isValid = validateFormOnSubmit();
			if (!isValid) {
				e.preventDefault(); // 제출 차단
			}
		});
	}

	// 운동 기록 입력 페이지
	if (pageType === 'exerciseRecordInput') {
		const durationInput = document.querySelector('#duration_minutes');
		if (durationInput) {
			durationInput.addEventListener('input', () => {
				const val = parseInt(durationInput.value || 0);
				if (val >= 60) showWizardMessage("이 정도면 하루치 마법을 다 썼군!");
				else if (val >= 30) showWizardMessage("좋아, 땀이 보이기 시작했어!");
			});
		}

		const calorieInput = document.querySelector('#calories_burned');
		if (calorieInput) {
			calorieInput.addEventListener('input', () => {
				const val = parseInt(calorieInput.value || 0);

				if (val >= 400) {
					showWizardMessage("와, 마법 에너지 풀파워였다구!");
				} else if (val >= 100) {
					showWizardMessage("좋아, 열심히 움직였네!");
				} else if (val > 0) {
					showWizardMessage("가볍게 몸을 풀었군!");
				}
			});
		}


		const exerciseSelect = document.querySelector('#exercise_id');
		if (exerciseSelect) {
			exerciseSelect.addEventListener('change', () => {
				const val = exerciseSelect.value;
				if (val === "1") showWizardMessage("가볍게 시작해보는 거지!");
				else if (val === "4") showWizardMessage("마력이 증가했구나!(물리)");
			});
		}

		const dateInput = document.querySelector('#activity_date');
		if (dateInput) {
			dateInput.addEventListener('change', () => {
				const today = new Date().toISOString().slice(0, 10);
				const selectedDate = dateInput.value;

				if (selectedDate) {
					if (selectedDate > today) {
						// 미래 입력은 반응하지 않음
						return;
					} else if (selectedDate === today) {
						showWizardMessage("오늘의 마법 시전 완료! 내일은 대마법인가?");
					} else {
						showWizardMessage("어제도 마법을 쓴 거야? 멋져!");
					}
				}
			});
		}

		const platformInput = document.querySelector('#source_platform');
		if (platformInput) {
			platformInput.addEventListener('input', () => {
				if (platformInput.value.trim() !== '') {
					showWizardMessage("소환 마법 발동!");
				}
			});
		}

	}

	// 운동 목록 페이지 전용
	if (pageType === 'exerciseRecordList') {
		const addBtn = document.querySelector("a[href*='exerciseRecordInput']");
		const editModeBtn = document.getElementById("toggleEditModeBtn");
		const deleteBtns = document.querySelectorAll("a[href*='exerciseRecordDelete']");
		const editBtns = document.querySelectorAll("a[href*='exerciseRecordEdit']");

		if (addBtn) {
			addBtn.addEventListener('mouseover', () => {
				showWizardMessage("새로운 마법 기록을 시작해볼까?");
			});
		}

		if (editModeBtn) {
			editModeBtn.addEventListener('mouseover', () => {
				showWizardMessage("전역 수정 마법진 발동!");
			});
		}

		editBtns.forEach(btn => {
			btn.addEventListener('mouseover', () => {
				showWizardMessage("무영창 수정 마법 시전?!");
			});
		});

		deleteBtns.forEach(btn => {
			btn.addEventListener('mouseover', () => {
				showWizardMessage("정말 마법의 흔적을 지우려는 거야?");
			});
		});
	}

	// 운동 기록 다중 입력 페이지
	if (pageType === 'exerciseRecordMultiInput') {
		const durationInputs = document.querySelectorAll('input[name*=".duration_minutes"]');
		durationInputs.forEach(input => {
			input.addEventListener('input', () => {
				const val = parseInt(input.value || 0);
				if (val >= 60) showWizardMessage("마력의 한계에 도전했군!");
				else if (val >= 30) showWizardMessage("좋아, 충분히 활동했어!");
			});
		});

		const calorieInputs = document.querySelectorAll('input[name*=".calories_burned"]');
		calorieInputs.forEach(input => {
			input.addEventListener('input', () => {
				const val = parseInt(input.value || 0);
				if (val >= 400) showWizardMessage("🔥 대마법 에너지 폭발!");
				else if (val >= 100) showWizardMessage("✨ 마법처럼 움직였네!");
				else if (val > 0) showWizardMessage("🐾 몸풀기 마법 완료!");
			});
		});

		const exerciseSelects = document.querySelectorAll('select[name*=".exercise_id"]');
		exerciseSelects.forEach(select => {
			select.addEventListener('change', () => {
				const val = select.value;
				if (val === "1") showWizardMessage("산책 마법은 언제나 좋아!");
				else if (val === "4") showWizardMessage("근력 마법으로 단련하자!");
			});
		});

		const dateInputs = document.querySelectorAll('input[name*=".activity_date"]');
		dateInputs.forEach(input => {
			input.addEventListener('change', () => {
				const today = new Date().toISOString().slice(0, 10);
				const selectedDate = input.value;

				if (selectedDate) {
					if (selectedDate > today) return;
					else if (selectedDate === today) showWizardMessage("오늘의 기록이군요! ⚡");
					else showWizardMessage("어제도 마법을 썼군요? 멋져요!");
				}
			});
		});
	}

	// 식단 기록 단건 입력 페이지 전용
	if (pageType === 'mealRecordInput') {
		const amountInput = document.getElementById('amount');
		const unitSelect = document.getElementById('unit');

		if (amountInput && unitSelect) {
			// 수치 입력 반응
			amountInput.addEventListener('input', () => {
				const val = parseFloat(amountInput.value || 0);
				if (val >= 500) showWizardMessage("이건 진짜 푸드 파워 마법이야!");
				else if (val >= 100) showWizardMessage("좋아, 꽤 든든한 식사였네!");
				else if (val > 0) showWizardMessage("가볍게 마법 식사를 했군요!");
			});

			// 단위 선택 반응
			unitSelect.addEventListener('change', () => {
				const unit = unitSelect.value;
				if (unit === "컵") showWizardMessage("마법의 컵에 담긴 영양이군요!");
				else if (unit === "공기") showWizardMessage("공기 마법 한 그릇, 진정한 클래식!");
			});
		}

		const foodSelect = document.querySelector('#food_id');
		if (foodSelect) {
			foodSelect.addEventListener('change', () => {
				const val = foodSelect.value;
				if (val === "2") showWizardMessage("단백질 마법을 시전하셨군요!");
				else if (val === "4") showWizardMessage("라면이라니… 죄책감 마법이 발동할지도?");
			});
		}

		const mealTimeSelect = document.querySelector('#meal_time');
		if (mealTimeSelect) {
			mealTimeSelect.addEventListener('change', () => {
				const val = mealTimeSelect.value;
				if (val === "1") showWizardMessage("좋은 아침이에요! 마법같은 하루의 시작이군요.");
				else if (val === "3") showWizardMessage("저녁 마법으로 하루를 마무리해요.");
			});
		}

		const dateInput = document.querySelector('#meal_date');
		if (dateInput) {
			dateInput.addEventListener('change', () => {
				const today = new Date().toISOString().slice(0, 10);
				const selectedDate = dateInput.value;

				if (selectedDate) {
					if (selectedDate > today) return;
					else if (selectedDate === today) showWizardMessage("오늘의 식단이군요! 🍽");
					else showWizardMessage("이전 식사를 기록했군요. 정리 마법 굿!");
				}
			});
		}
	}

	// 식단 기록 다중 입력 페이지 전용
	if (pageType === 'mealRecordMultiInput') {
		const rows = document.querySelectorAll("#recordTableBody tr");

		// 동적으로 추가될 행은 이벤트 위임이 어렵기 때문에, 초기화 시점마다 전체 바인딩 필요
		function bindMealRowEvents() {
			const amountInputs = document.querySelectorAll('input[id^="amount"]');
			const unitSelects = document.querySelectorAll('select[id^="unit"]');
			const foodSelects = document.querySelectorAll('select[name*=".food_id"]');
			const dateInputs = document.querySelectorAll('input[name*=".meal_date"]');
			const timeSelects = document.querySelectorAll('select[name*=".meal_time"]');

			amountInputs.forEach(input => {
				input.addEventListener('input', () => {
					const val = parseFloat(input.value || 0);
					if (val >= 500) showWizardMessage("이건 진짜 푸드 파워 마법이야!");
					else if (val >= 100) showWizardMessage("좋아, 꽤 든든한 식사였네!");
					else if (val > 0) showWizardMessage("가볍게 마법 식사를 했군요!");
				});
			});

			unitSelects.forEach(select => {
				select.addEventListener('change', () => {
					const unit = select.value;
					if (unit === "컵") showWizardMessage("마법의 컵에 담긴 영양이군요!");
					else if (unit === "공기") showWizardMessage("공기 마법 한 그릇, 진정한 클래식!");
				});
			});

			foodSelects.forEach(select => {
				select.addEventListener('change', () => {
					const val = select.value;
					if (val === "2") showWizardMessage("단백질 마법을 시전하셨군요!");
					else if (val === "4") showWizardMessage("라면이라니… 죄책감 마법이 발동할지도?");
				});
			});

			dateInputs.forEach(input => {
				input.addEventListener('change', () => {
					const today = new Date().toISOString().slice(0, 10);
					const selectedDate = input.value;

					if (selectedDate) {
						if (selectedDate > today) return;
						else if (selectedDate === today) showWizardMessage("오늘의 식단이군요! 🍽");
						else showWizardMessage("이전 식사를 기록했군요. 정리 마법 굿!");
					}
				});
			});

			timeSelects.forEach(select => {
				select.addEventListener('change', () => {
					const val = select.value;
					if (val === "1") showWizardMessage("좋은 아침이에요! 마법같은 하루의 시작이군요.");
					else if (val === "2") showWizardMessage("점심 마법으로 활력을 충전했네요!");
					else if (val === "3") showWizardMessage("저녁 마법으로 하루를 마무리해요.");
					else if (val === "4") showWizardMessage("간식은 마법사의 쉼표 같은 존재죠.");
				});
			});

		}

		bindMealRowEvents();

		// 새 행 추가 시 이벤트 재바인딩 필요 → 기존 addRow 끝에 호출
		if (typeof window.addRow === "function") {
			const originalAddRow = window.addRow;
			window.addRow = function() {
				originalAddRow();
				bindMealRowEvents();
			};
		}

	}

	// 식단 목록 페이지 전용
	if (pageType === 'mealRecordList') {
		const addBtn = document.querySelector("a[href*='mealRecordInput']");
		const editModeBtn = document.getElementById("toggleEditModeBtn");
		const deleteBtns = document.querySelectorAll("a[href*='mealRecordDelete']");
		const editBtns = document.querySelectorAll("a[href*='mealRecordEdit']");

		if (addBtn) {
			addBtn.addEventListener('mouseover', function() {
				showWizardMessage("🍱 새로운 마법 식사를 시작해볼까요?");
			});
		}

		if (editModeBtn) {
			editModeBtn.addEventListener('mouseover', function() {
				showWizardMessage("✏️ 전역 수정 마법진, 시전 준비 완료!");
			});
		}

		editBtns.forEach(function(btn) {
			btn.addEventListener('mouseover', function() {
				showWizardMessage("🔧 무영창 식단 수정 마법!");
			});
		});

		deleteBtns.forEach(function(btn) {
			btn.addEventListener('mouseover', function() {
				showWizardMessage("❌ 마법 식사를 지우려는 거예요?");
			});
		});
	}


});

// 검증 로직 수행 (submit 시점)
function validateFormOnSubmit(scope = document) {
	const inputs = scope.querySelectorAll('input, select, textarea'); // 여기 수정
	let isValid = true;

	for (const el of inputs) {
		if (!el.required) continue;

		const type = el.type;
		const val = el.value.trim();

		if ((type === 'text' || el.tagName === 'TEXTAREA') && val === '') {
			showWizardMessage("이건 너무 비어있지 않니?");
			el.focus();
			isValid = false;
			break;
		}

		if (type === 'number') {
			const numVal = parseFloat(val);

			// 운동 기록용 숫자 필드 (정수만 허용)
			if (pageType.startsWith('exercise') && (el.id === 'duration_minutes' || el.id === 'calories_burned')) {
				if (isNaN(numVal) || numVal <= 0 || !Number.isInteger(numVal)) {
					showWizardMessage("0이나 소숫점, 음수는 마법이 허용하지 않아!");
					el.focus();
					isValid = false;
					break;
				}
			}

			// 식단 입력용 amount (단건/다중 공통)
			if (el.id && el.id.startsWith('amount')) {
				if (isNaN(numVal) || numVal <= 0) {
					showWizardMessage("섭취량은 0보다 큰 수여야 해요!");
					el.focus();
					isValid = false;
					break;
				}
				// 단위 입력 검사 (id 대응)
				const unitId = el.id.replace('amount', 'unit');
				const unitEl = document.getElementById(unitId);
				if (unitEl && unitEl.value.trim() === '') {
					showWizardMessage("단위를 선택해 주세요!");
					unitEl.focus();
					isValid = false;
					break;
				}
			}
		}

		if (type === 'date') {
			const today = new Date().toISOString().slice(0, 10);

			// 운동 기록/식단 기록 페이지: 미래 금지
			if (pageType !== 'goal' && val > today) {
				showWizardMessage("미래를 보고온거야...?");
				el.focus();
				isValid = false;
				break;
			}

			// 목표 설정 페이지: 과거 금지
			if (pageType === 'goal' && val < today) {
				showWizardMessage("과거 시간 마법은 금지된 마법이라구!");
				el.focus();
				isValid = false;
				break;
			}
		}


		if (el.tagName === 'SELECT' && val === '') {
			showWizardMessage("마법을 선택해줘야 하지 않을까?");
			el.focus();
			isValid = false;
			break;
		}
	}

	return isValid;
}


// 메시지 출력 함수
function showWizardMessage(message) {
	const msgBox = document.querySelector('#wizard-message');
	if (!msgBox) return;

	msgBox.textContent = message;
	msgBox.style.display = 'block';

	setTimeout(() => {
		msgBox.style.display = 'none';
	}, 3000);
}
