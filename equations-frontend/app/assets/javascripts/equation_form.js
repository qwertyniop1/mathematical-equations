document.addEventListener('turbolinks:load', () => {
    const expression = document.querySelector('.equation__input');
    const inputs = document.querySelectorAll('.form input[type=number]');
    const form = document.querySelector('.form');

    inputs.forEach(input => input.addEventListener('change', (event) => {
        expression.innerHTML = getNewExpression(inputs);
    }));

    inputs.forEach(input => input.addEventListener('input', (event) => {
        validate(event.target);
    }));

    if (form) {
        form.querySelector('input[type=submit').addEventListener('click', (event) => {
            const coefficient_a = document.getElementById('coefficient_a');
            const errors = document.querySelector('.equation__error');

            if (coefficient_a.value === '0') {
                event.preventDefault();
                coefficient_a.classList.add('error');
                errors.innerHTML = 'Coefficient A cannot equals to 0.'
                errors.classList.remove('hidden');
            } else {
                coefficient_a.classList.remove('error');
                errors.classList.add('hidden');
            }
        });
    }

    expression.innerHTML = getNewExpression(inputs);
});

document.addEventListener('ajax:send', (event, xhr, options) => {
    document.querySelector('.fade').classList.remove('hidden');
});

document.addEventListener('ajax:complete', (event, xhr, status) => {
    document.querySelector('.fade').classList.add('hidden');
});

const getNewExpression = (inputs) => {
    const [a, b, c] = [].map.call(inputs, input => input.value || 0);
    if (inputs.length === 3) {
        return `\`${a}x^2${numberWithSign(b)}x${numberWithSign(c)}=0\``;
    }
    return `\`${a}x${numberWithSign(b)}=0\``;
};

const numberWithSign = number => number >= 0 ? `+${number}` : `${number}`;

const validate = (input) => {
    const value = input.value;
    if (value.length > 10) {
        input.value = value.slice(0, -1);
    }
};
