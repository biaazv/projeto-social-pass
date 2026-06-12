document.addEventListener('DOMContentLoaded', function() {

    var API_BASE_URL = 'http://localhost:8080';
    if (window.location.port === '8080') {
        API_BASE_URL = window.location.origin;
    }

    var toastContainer = document.getElementById('toastContainer');
    var form = document.getElementById('loginForm');
    var mensagem = document.getElementById('formMessage');
    var botaoSubmit = form ? form.querySelector('.btn-submit') : null;

    
    var radiosPerfil = document.querySelectorAll('input[name="tipoPerfil"]');
    var labelIdentificacao = document.getElementById('labelIdentificacao');
    var inputIdentificacao = document.getElementById('identificacaoLoginInput');
    var iconeIdentificacao = document.getElementById('iconeIdentificacao');

    
    function escapeHtml(text) {
        return String(text || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function mostrarToast(msg, tipo) {
        if (!toastContainer) {
            alert(msg);
            return;
        }
        var toast = document.createElement('div');
        toast.className = 'toast ' + tipo;
        toast.innerHTML = escapeHtml(msg);
        toastContainer.appendChild(toast);

        setTimeout(function() {
            toast.remove();
        }, 4200);
    }

    function mostrarMensagem(elemento, msg, tipo) {
        if (!elemento) return;
        elemento.textContent = msg;
        elemento.className = 'form-message ' + tipo;
    }

    function validarEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test((email || '').trim());
    }

    function limparNaoDigitos(value) {
        return (value || '').replace(/\D/g, '');
    }

    
    
if (radiosPerfil.length > 0 && inputIdentificacao) {
    radiosPerfil.forEach(function(radio) {
        radio.addEventListener('change', function(e) {
            // Limpa o campo para evitar que o CNPJ fique lá se o usuário mudar de ideia
            inputIdentificacao.value = ''; 
            mostrarMensagem(mensagem, '', '');

            if (e.target.value === 'academia') {
                // Configuração para Instituição (CNPJ)
                labelIdentificacao.textContent = 'CNPJ da Instituição';
                inputIdentificacao.type = 'text';
                inputIdentificacao.placeholder = '00.000.000/0000-00';
                iconeIdentificacao.innerHTML = '&#128188;';
            } else {
                // Configuração para Beneficiário (Email) - AGORA ELE RESETARÁ CORRETAMENTE
                labelIdentificacao.textContent = 'Email';
                inputIdentificacao.type = 'email';
                inputIdentificacao.placeholder = 'Digite seu email';
                iconeIdentificacao.innerHTML = '&#9993;';
            }
        });
    });

        
        inputIdentificacao.addEventListener('input', function(e) {
            var perfilSelecionado = document.querySelector('input[name="tipoPerfil"]:checked').value;
            
        
            if (perfilSelecionado === 'academia') {
                var value = limparNaoDigitos(e.target.value);
                
                if (value.length > 14) value = value.slice(0, 14); 
                
            
                if (value.length > 12) {
                    value = value.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2}).*/, '$1.$2.$3/$4-$5');
                } else if (value.length > 8) {
                    value = value.replace(/^(\d{2})(\d{3})(\d{3})(\d{0,4}).*/, '$1.$2.$3/$4');
                } else if (value.length > 5) {
                    value = value.replace(/^(\d{2})(\d{3})(\d{0,3}).*/, '$1.$2.$3');
                } else if (value.length > 2) {
                    value = value.replace(/^(\d{2})(\d{0,3}).*/, '$1.$2');
                }
                
                e.target.value = value;
            }
        });
    }
    
    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            var formData = new FormData(form);
            var identificacao = (formData.get('identificacao') || '').trim();
            var senha = (formData.get('senha') || '').trim();
            var tipoPerfil = formData.get('tipoPerfil');

            
            if (tipoPerfil === 'usuario') {
                if (!validarEmail(identificacao)) {
                    mostrarToast('Por favor, insira um email válido.', 'error');
                    return;
                }
            } else if (tipoPerfil === 'academia') {
                var cnpjLimpo = limparNaoDigitos(identificacao);
                if (cnpjLimpo.length !== 14) {
                    mostrarToast('Por favor, insira um CNPJ válido com 14 dígitos.', 'error');
                    return;
                }
            }

            if (!senha) {
                mostrarToast('A senha é obrigatória.', 'error');
                return;
            }

        
            var payload = {
                email: identificacao, 
                senha: senha,
                tipoPerfil: tipoPerfil
            };

            try {
                if (botaoSubmit) botaoSubmit.disabled = true;
                mostrarMensagem(mensagem, 'Validando credenciais...', '');

                var response = await fetch(API_BASE_URL + '/api/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    var erroTexto = 'Credenciais inválidas. Tente novamente.';
                    try {
                        var text = await response.text();
                        if (text) erroTexto = text;
                    } catch (err) {}
                    
                    mostrarMensagem(mensagem, erroTexto, 'error');
                    mostrarToast(erroTexto, 'error');
                    return;
                }

        
                mostrarMensagem(mensagem, 'Login realizado com sucesso!', 'success');
                mostrarToast('Acesso liberado!', 'success');
                
            
                setTimeout(function() {
                    if (tipoPerfil === 'usuario') {
                        window.location.href = 'painel-usuario.html';
                    } else {
                        window.location.href = 'painel-academia.html';
                    }
                }, 1000);

            } catch (error) {
                var textoErro = 'Falha ao conectar com o servidor. O back-end está rodando?';
                mostrarMensagem(mensagem, textoErro, 'error');
                mostrarToast(textoErro, 'error');
            } finally {
                if (botaoSubmit) botaoSubmit.disabled = false;
            }
        });
    }
});