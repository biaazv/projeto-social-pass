document.addEventListener('DOMContentLoaded', function() {
    // Configuração da URL do Backend
    // Se estiver em produção, pode ser necessário ajustar essa lógica ou usar variáveis de ambiente no build
    var API_BASE_URL = 'http://localhost:8080';

    // Se o frontend for servido pelo Spring Boot (mesma origem), usa o origin atual
    if (window.location.port === '8080') {
        API_BASE_URL = window.location.origin;
    }

    var toastContainer = document.getElementById('toastContainer');

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

    function limparNaoDigitos(value) {
        return (value || '').replace(/\D/g, '');
    }

    function escapeHtml(text) {
        return String(text || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function mostrarToast(mensagem, tipo) {
        if (!toastContainer) {
            alert(mensagem);
            return;
        }

        var toast = document.createElement('div');
        toast.className = 'toast ' + tipo;
        toast.innerHTML = escapeHtml(mensagem);
        toastContainer.appendChild(toast);

        setTimeout(function() {
            toast.remove();
        }, 4200);
    }

    function mostrarMensagem(elemento, mensagem, tipo) {
        if (!elemento) {
            return;
        }

        elemento.textContent = mensagem;
        elemento.className = 'form-message ' + tipo;
    }

    function validarCPF(cpf) {
        var value = limparNaoDigitos(cpf);

        if (value.length !== 11) {
            return false;
        }

        if (/^(\d)\1+$/.test(value)) {
            return false;
        }

        var soma = 0;
        var resto;

        for (var i = 1; i <= 9; i++) {
            soma += parseInt(value.substring(i - 1, i), 10) * (11 - i);
        }

        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) {
            resto = 0;
        }
        if (resto !== parseInt(value.substring(9, 10), 10)) {
            return false;
        }

        soma = 0;
        for (var j = 1; j <= 10; j++) {
            soma += parseInt(value.substring(j - 1, j), 10) * (12 - j);
        }

        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) {
            resto = 0;
        }

        return resto === parseInt(value.substring(10, 11), 10);
    }

    function validarSenha(senha) {
        return /^(?=.*[A-Z])(?=.*\d).{4,}$/.test(senha || '');
    }

    function validarEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test((email || '').trim());
    }

    function validarNomeUsuario(nomeUsuario) {
        return /^[a-zA-Z0-9._-]{3,50}$/.test((nomeUsuario || '').trim());
    }

    function validarDataNascimento(dataNascimento) {
        var value = (dataNascimento || '').trim();
        if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
            return false;
        }

        var partes = value.split('-');
        var ano = parseInt(partes[0], 10);
        var mes = parseInt(partes[1], 10);
        var dia = parseInt(partes[2], 10);

        var hoje = new Date();
        var anoAtual = hoje.getFullYear();

        if (ano > anoAtual || ano < 1900 || mes < 1 || mes > 12 || dia < 1) {
            return false;
        }

        var data = new Date(ano, mes - 1, dia);
        if (
            data.getFullYear() !== ano ||
            data.getMonth() !== (mes - 1) ||
            data.getDate() !== dia
        ) {
            return false;
        }

        return data <= hoje;
    }

    // Submit do formulario
    var form = document.getElementById('cadastroForm');
    var mensagem = document.getElementById('formMessage');
    var botaoSubmit = form ? form.querySelector('.btn-submit') : null;
    var dataNascimentoInput = document.getElementById('dataNascimentoInput');

    if (dataNascimentoInput) {
        var hoje = new Date();
        var hojeIso = hoje.toISOString().split('T')[0];
        dataNascimentoInput.setAttribute('max', hojeIso);
    }

    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            var formData = new FormData(form);
            var nomeCompleto = (formData.get('nomeCompleto') || '').trim();
            var nomeUsuario = (formData.get('nomeUsuario') || '').trim();
            var cpf = limparNaoDigitos(formData.get('cpf'));
            var dataNascimento = formData.get('dataNascimento');
            var email = (formData.get('email') || '').trim();
            var telefone = limparNaoDigitos(formData.get('telefone'));
            var senha = (formData.get('senha') || '').trim();

            if (!nomeCompleto || nomeCompleto.length < 3) {
                mostrarToast('Informe um nome completo válido.', 'error');
                return;
            }

            if (!validarNomeUsuario(nomeUsuario)) {
                mostrarToast('Nome de usuário inválido. Use 3 a 50 caracteres e sem espaços.', 'error');
                return;
            }

            if (!validarCPF(cpf)) {
                mostrarToast('CPF inválido.', 'error');
                return;
            }

            if (!validarEmail(email)) {
                mostrarToast('Email inválido.', 'error');
                return;
            }

            if (!dataNascimento) {
                mostrarToast('Informe a data de nascimento.', 'error');
                return;
            }

            if (!validarDataNascimento(dataNascimento)) {
                mostrarToast('Data de nascimento inválida. Use uma data existente e não futura.', 'error');
                return;
            }

            if (!validarSenha(senha)) {
                mostrarToast('Senha deve ter no mínimo 4 caracteres, 1 letra maiúscula e 1 número.', 'error');
                return;
            }

            var payload = {
                nomeCompleto: nomeCompleto,
                nomeUsuario: nomeUsuario,
                cpf: cpf,
                dataNascimento: dataNascimento,
                email: email,
                telefone: telefone,
                senha: senha,
                statusConta: 'ATIVO'
            };

            try {
                if (botaoSubmit) {
                    botaoSubmit.disabled = true;
                }

                mostrarMensagem(mensagem, 'Enviando cadastro...', '');

                var response = await fetch(API_BASE_URL + '/api/usuarios', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    var erroTexto = 'Erro ao cadastrar usuário.';
                    try {
                        var erroBody = await response.json();
                        // Spring Boot Default Error or Custom Error
                        erroTexto = erroBody.message || erroBody.erro || erroBody.detail || erroTexto;

                        if (erroBody.errors && Array.isArray(erroBody.errors)) {
                            erroTexto = erroBody.errors[0].defaultMessage || erroTexto;
                        }
                    } catch (err) {
                        try {
                            var text = await response.text();
                            if (text) erroTexto = text;
                        } catch (textoErr) {}
                    }
                    mostrarMensagem(mensagem, erroTexto, 'error');
                    mostrarToast(erroTexto, 'error');
                    return;
                }

                mostrarMensagem(mensagem, 'Cadastro realizado com sucesso!', 'success');
                mostrarToast('Cadastro realizado com sucesso!', 'success');
                form.reset();
            } catch (error) {
                var textoErro = error.message || 'Falha ao conectar com o servidor.';
                mostrarMensagem(mensagem, textoErro, 'error');
                mostrarToast(textoErro, 'error');
            } finally {
                if (botaoSubmit) {
                    botaoSubmit.disabled = false;
                }
            }
        });
    }

    // ==========================================
    // LÓGICA DA TELA DE LOGIN (login.html)
    // ==========================================
    
    var cpfLoginInput = document.getElementById('cpfLoginInput');

    // Reaproveita a máscara de CPF para a tela de login
    if (cpfLoginInput) {
        cpfLoginInput.addEventListener('input', function(e) {
            var value = e.target.value.replace(/\D/g, '');
            if (value.length > 11) value = value.slice(0, 11);
            if (value.length > 9) value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{1,2})/, '$1.$2.$3-$4');
            else if (value.length > 6) value = value.replace(/(\d{3})(\d{3})(\d{1,3})/, '$1.$2.$3');
            else if (value.length > 3) value = value.replace(/(\d{3})(\d{1,3})/, '$1.$2');
            e.target.value = value;
        });
    }

    var loginForm = document.getElementById('loginForm');
    var loginMessage = document.getElementById('loginMessage');

    if (loginForm) {
        loginForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            var formData = new FormData(loginForm);
            var cpf = limparNaoDigitos(formData.get('cpf'));
            var senha = formData.get('senha');

            if (!validarCPF(cpf)) {
                mostrarToast('CPF inválido.', 'error');
                return;
            }

            if (!senha) {
                mostrarToast('Por favor, informe a senha.', 'error');
                return;
            }

            // Simulação de Login (Substitua pela chamada Fetch real para sua API)
            mostrarMensagem(loginMessage, 'Consultando CadÚnico e autenticando...', '');
            
            setTimeout(function() {
                mostrarToast('Login realizado com sucesso!', 'success');
                // Redireciona para a Home após o login
                window.location.href = 'home.html';
            }, 1500);
        });
    }

    // ==========================================
    // LÓGICA DO MAPA (home.html)
    // ==========================================
    
    var mapContainer = document.getElementById('mapaAcademias');
    
    if (mapContainer && typeof L !== 'undefined') {
        // Inicializa o mapa focado no Rio de Janeiro (entre as zonas Norte e Oeste)
        var mapa = L.map('mapaAcademias', {
            zoomControl: false // Remove os botões de + e - para ficar mais clean
        }).setView([-22.8700, -43.3400], 11); 

        // Carrega o visual do mapa (OpenStreetMap)
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap'
        }).addTo(mapa);

        // Lista de Academias com Coordenadas aproximadas dos bairros
        var academiasParceiras = [
            { nome: "Academia Boa Forma", atividade: "Musculação", lat: -22.8790, lng: -43.4630 }, // Bangu
            { nome: "Clube Aquático", atividade: "Hidroginástica", lat: -22.8740, lng: -43.3360 }, // Madureira
            { nome: "Centro de Lutas Maré", atividade: "Muay Thai", lat: -22.8590, lng: -43.2430 } // Maré
        ];

        // Adiciona um marcador azul padrão para cada academia
        academiasParceiras.forEach(function(academia) {
            var marker = L.marker([academia.lat, academia.lng]).addTo(mapa);
            
            // Adiciona um balão de texto quando clica no marcador
            marker.bindPopup(
                '<strong style="color: #1a4b8c;">' + academia.nome + '</strong><br>' + 
                '<span style="font-size: 12px; color: #666;">' + academia.atividade + '</span>'
            );
        });
    }
});