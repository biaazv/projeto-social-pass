document.addEventListener('DOMContentLoaded', function() {
    
    // Mascara de CPF
    var cpfInput = document.getElementById('cpfInput');
    
    if (cpfInput) {
        cpfInput.addEventListener('input', function(e) {
            var value = e.target.value.replace(/\D/g, '');
            
            if (value.length > 11) {
                value = value.slice(0, 11);
            }
            
            if (value.length > 9) {
                value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{1,2})/, '$1.$2.$3-$4');
            } else if (value.length > 6) {
                value = value.replace(/(\d{3})(\d{3})(\d{1,3})/, '$1.$2.$3');
            } else if (value.length > 3) {
                value = value.replace(/(\d{3})(\d{1,3})/, '$1.$2');
            }
            
            e.target.value = value;
        });
    }

    // Mascara de Telefone
    var telefoneInput = document.getElementById('telefoneInput');
    
    if (telefoneInput) {
        telefoneInput.addEventListener('input', function(e) {
            var value = e.target.value.replace(/\D/g, '');
            
            if (value.length > 11) {
                value = value.slice(0, 11);
            }
            
            if (value.length > 10) {
                value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
            } else if (value.length > 6) {
                value = value.replace(/(\d{2})(\d{4,5})(\d{0,4})/, '($1) $2-$3');
            } else if (value.length > 2) {
                value = value.replace(/(\d{2})(\d{0,5})/, '($1) $2');
            }
            
            e.target.value = value;
        });
    }
    
    // Submit do formulario
    var form = document.getElementById('cadastroForm');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            alert('Cadastro realizado com sucesso!');
        });
    }
    
});