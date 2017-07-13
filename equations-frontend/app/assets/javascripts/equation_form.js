const getNewExpression = (inputs) => {
    const [a, b, c] = [].map.call(inputs, input => parseFloat(input.value) || 0);
    if (inputs.length === 3) {
        return `\`${a}*x^2${numberWithSign(b)}*x${numberWithSign(c)}=0\``;
    }
    return `\`${a}*x${numberWithSign(b)}=0\``;
};

const numberWithSign = number => number >= 0 ? `+${number}` : `${number}`;

const validate = (input) => {
    const value = input.value;
    if (value.length > 10) {
        input.value = value.slice(0, -1);
    }
};

const errors = {
    init(selector) {
        this.element = document.querySelector(selector);
    },
    show (message) {
        this.element.innerHTML = message;
        this.element.classList.add('visible');

        const self = this;
        setTimeout(() => {
            self.hide();
        }, 5000);
    },
    hide() {
        this.element.classList.remove('visible');
    },
};

const renderFormulas = (target) => {
    if (typeof MathJax !== 'undefined') {
        MathJax.Hub.Queue(['Typeset', MathJax.Hub, target]);
    }
};


document.addEventListener('turbolinks:load', () => {
    const expression = document.querySelector('.equation__input');
    const inputs = document.querySelectorAll('.form input[type=number]');
    const form = document.querySelector('.form');

    inputs.forEach(input => input.addEventListener('change', (event) => {
        expression.innerHTML = getNewExpression(inputs);
        renderFormulas(expression);
    }));

    inputs.forEach(input => input.addEventListener('input', (event) => {
        validate(event.target);
    }));

    errors.init('.equation__error');

    if (form) {
        form.querySelector('input[type=submit]').addEventListener('click', (event) => {
            const coefficientA = document.getElementById('coefficient_a');

            if (!parseFloat(coefficientA.value)) {
                event.preventDefault();
                coefficientA.classList.add('error');
                errors.show('Coefficient A cannot equals to 0.');

            } else {
                coefficientA.classList.remove('error');
                errors.hide();
            }
        });

        expression.innerHTML = getNewExpression(inputs);
    }

    renderFormulas(document.body);
});

document.addEventListener('ajax:send', (event, xhr, options) => {
    document.querySelector('.fade').classList.remove('hidden');
});

document.addEventListener('ajax:complete', (event, xhr, status) => {
    document.querySelector('.fade').classList.add('hidden');
});

document.addEventListener('ajax:error', (event, xhr, status) => {
    errors.show('Server error occured. Please, try again later.')
});

document.addEventListener('ajax:success', (event, xhr, status) => {
    const solution = document.querySelector('.equation__solution');
    renderFormulas(solution);
});
