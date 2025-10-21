//Модуль для валидации формы


class FormValidator {
    constructor() {
        this.errorMessages = {
            x: {
                required: 'Выберите значение X',
                range: 'X должно быть от -5 до 3'
            },
            y: {
                required: 'Введите значение Y',
                number: 'Y должно быть числом',
                range: 'Y должно быть в диапазоне (-5; 5)'
            },
            r: {
                required: 'Введите значение R',
                number: 'R должно быть числом',
                range: 'R должно быть в диапазоне (1, 4)'
            }
        };
    }

    showError(message) {
        let errorDiv = document.getElementById('error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.id = 'error-message';
            errorDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; border: 1px solid #f5c6cb; z-index: 1000; max-width: 300px;';
            document.body.appendChild(errorDiv);
        }
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';

        setTimeout(() => {
            errorDiv.style.display = 'none';
        }, 5000);
    }


    resetErrors() {
        document.querySelectorAll('.error-message').forEach(el => el.classList.remove('show'));
    }




    showFieldError(fieldId, message) {
        const errorElement = document.getElementById(fieldId + '-error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.add('show');
        }
    }

    validateX() {
        const xSelect = document.getElementById('x-select');
        if (!xSelect.value) {
            this.showFieldError('x', this.errorMessages.x.required);
            return false;
        } else {
            const xValue = parseFloat(xSelect.value);
            if (xValue < -5 || xValue > 3) {
                this.showFieldError('x', this.errorMessages.x.range);
                return false;
            }
        }
        return true;
    }


    validateY() {
        const yInput = document.getElementById('y-input');
        const yValue = yInput.value.trim().replace(',', '.');
        
        if (!yValue) {
            this.showFieldError('y', this.errorMessages.y.required);
            return false;
        } else if (isNaN(yValue)) {
            this.showFieldError('y', this.errorMessages.y.number);
            return false;
        } else {
            const y = parseFloat(yValue);
            if (y <= -5 || y >= 5) {
                this.showFieldError('y', this.errorMessages.y.range);
                return false;
            } else {
                // Сохраняем точное значение без ограничения точности
                yInput.value = yValue;
            }
        }
        return true;
    }


    validateR() {
        const rInput = document.getElementById('r-input');
        const rValue = rInput.value.trim().replace(',', '.');
        
        if (!rValue) {
            this.showFieldError('r', this.errorMessages.r.required);
            return false;
        } else if (isNaN(rValue)) {
            this.showFieldError('r', this.errorMessages.r.number);
            return false;
        } else {
            const r = parseFloat(rValue);
            if (r <= 1 || r >= 4) {
                this.showFieldError('r', this.errorMessages.r.range);
                return false;
            } else {

                rInput.value = rValue;
            }
        }
        return true;
    }


    validateCoordinates(x, y) {
        if (x < -5 || x > 3) {
            this.showError('Координата X должна быть в диапазоне от -5 до 3');
            return false;
        }
        if (y <= -5 || y >= 5) {
            this.showError('Координата Y должна быть в диапазоне от -5 до 5');
            return false;
        }
        return true;
    }

    /**
     * Полная валидация формы
     */
    validateForm() {
        this.resetErrors();
        
        const isXValid = this.validateX();
        const isYValid = this.validateY();
        const isRValid = this.validateR();
        
        return isXValid && isYValid && isRValid;
    }
}
