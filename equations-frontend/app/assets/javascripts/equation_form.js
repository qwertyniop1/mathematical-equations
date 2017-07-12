document.addEventListener('turbolinks:load', () => {
    const expression = document.querySelector('.equation__input');
    const inputs = document.querySelectorAll('.form input[type=number]');

    inputs.forEach(input => input.addEventListener('change', (event) => {
        expression.innerHTML = getNewExpression(inputs);
    }));

    inputs.forEach(input => input.addEventListener('input', (event) => {
        validate(event.target);
    }));

    document.querySelector('.form').addEventListener('submit', (e) => {
        const coefficientA = document.getElementById('coefficient_a');
        if (coefficientA.value === '0') {
            alert('Coefficient A cannot equals to 0!');
            e.preventDefault();
            return;
        }
        e.preventDefault();
    });

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
