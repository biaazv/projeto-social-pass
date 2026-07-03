document.addEventListener('DOMContentLoaded', function () {
    var API_BASE_URL = 'http://localhost:8080';
    if (window.location.port === '8080') {
        API_BASE_URL = window.location.origin;
    }

    var toastContainer = document.getElementById('toastContainer');

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
        setTimeout(function () { toast.remove(); }, 4200);
    }

    function mostrarMensagem(elemento, mensagem, tipo) {
        if (!elemento) return;
        elemento.textContent = mensagem;
        elemento.className = 'form-message ' + tipo;
        elemento.hidden = false;
    }

    function salvarSessao(usuario) {
        sessionStorage.setItem('socialpass_usuario', JSON.stringify(usuario));
    }

    function obterSessao() {
        try {
            var dados = sessionStorage.getItem('socialpass_usuario');
            return dados ? JSON.parse(dados) : null;
        } catch (e) {
            sessionStorage.removeItem('socialpass_usuario');
            return null;
        }
    }

    function encerrarSessao() {
        sessionStorage.removeItem('socialpass_usuario');
    }

    function exigirLogin() {
        if (!obterSessao()) {
            window.location.href = 'login.html';
            return false;
        }
        return true;
    }

    function aplicarMascaraCPF(input) {
        if (!input) return;
        input.addEventListener('input', function (e) {
            var value = limparNaoDigitos(e.target.value).slice(0, 11);
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

    function aplicarMascaraCNPJ(input) {
        if (!input) return;
        input.addEventListener('input', function (e) {
            var value = limparNaoDigitos(e.target.value).slice(0, 14);
            if (value.length > 12) {
                value = value.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{1,2})/, '$1.$2.$3/$4-$5');
            } else if (value.length > 8) {
                value = value.replace(/(\d{2})(\d{3})(\d{3})(\d{1,4})/, '$1.$2.$3/$4');
            } else if (value.length > 5) {
                value = value.replace(/(\d{2})(\d{3})(\d{1,3})/, '$1.$2.$3');
            } else if (value.length > 2) {
                value = value.replace(/(\d{2})(\d{1,3})/, '$1.$2');
            }
            e.target.value = value;
        });
    }

    function validarCPF(cpf) {
        var value = limparNaoDigitos(cpf);
        if (value.length !== 11) return false;
        if (/^(\d)\1+$/.test(value)) return false;
        var soma = 0, resto;
        for (var i = 1; i <= 9; i++) soma += parseInt(value.substring(i - 1, i), 10) * (11 - i);
        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) resto = 0;
        if (resto !== parseInt(value.substring(9, 10), 10)) return false;
        soma = 0;
        for (var j = 1; j <= 10; j++) soma += parseInt(value.substring(j - 1, j), 10) * (12 - j);
        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) resto = 0;
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
        if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
        var partes = value.split('-');
        var ano = parseInt(partes[0], 10);
        var mes = parseInt(partes[1], 10);
        var dia = parseInt(partes[2], 10);
        var hoje = new Date();
        if (ano > hoje.getFullYear() || ano < 1900 || mes < 1 || mes > 12 || dia < 1) return false;
        var data = new Date(ano, mes - 1, dia);
        if (data.getFullYear() !== ano || data.getMonth() !== (mes - 1) || data.getDate() !== dia) return false;
        return data <= hoje;
    }

    var loginForm = document.getElementById('loginForm');
    var loginMessage = document.getElementById('loginMessage');
    var loginBotao = loginForm ? loginForm.querySelector('.btn-submit') : null;
    var loginBotaoHTML = loginBotao ? loginBotao.innerHTML : '';

    if (loginForm) {
        if (obterSessao()) {
            window.location.href = 'home.html';
            return;
        }

        aplicarMascaraCPF(document.getElementById('cpfLoginInput'));

        loginForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            var emailValor = document.getElementById('emailLoginInput').value.trim();
            var senhaValor = document.getElementById('senhaLoginInput').value.trim();

            if (!validarEmail(emailValor)) {
                mostrarMensagem(loginMessage, 'Email inválido.', 'error');
                return;
            }

            if (!senhaValor) {
                mostrarMensagem(loginMessage, 'Informe sua senha.', 'error');
                return;
            }

            try {
                loginBotao.disabled = true;
                loginBotao.innerHTML = 'Entrando...';
                mostrarMensagem(loginMessage, 'Verificando credenciais...', '');

                var response = await fetch(API_BASE_URL + '/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: emailValor, senha: senhaValor })
                });

                if (!response.ok) {
                    var erroTexto = 'Credenciais inválidas.';
                    try {
                        var erroBody = await response.json();
                        erroTexto = erroBody.message || erroBody.erro || erroBody.detail || erroTexto;
                    } catch (_) {}
                    mostrarMensagem(loginMessage, erroTexto, 'error');
                    return;
                }

                var usuario = await response.json();
                salvarSessao(usuario);
                window.location.href = 'home.html';
            } catch (error) {
                mostrarMensagem(loginMessage, error.message || 'Falha ao conectar com o servidor.', 'error');
            } finally {
                loginBotao.disabled = false;
                loginBotao.innerHTML = loginBotaoHTML;
            }
        });
    }

    var loginAcademiaForm = document.getElementById('loginAcademiaForm');
    var loginAcademiaMessage = document.getElementById('loginAcademiaMessage');
    var loginAcademiaBotao = loginAcademiaForm ? loginAcademiaForm.querySelector('.btn-submit') : null;
    var loginAcademiaBotaoHTML = loginAcademiaBotao ? loginAcademiaBotao.innerHTML : '';

    if (loginAcademiaForm) {
        aplicarMascaraCNPJ(document.getElementById('cnpjLoginAcademiaInput'));

        loginAcademiaForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            var cnpjValor = limparNaoDigitos(document.getElementById('cnpjLoginAcademiaInput').value);
            var senhaValor = document.getElementById('senhaLoginAcademiaInput').value.trim();

            if (cnpjValor.length !== 14) {
                mostrarMensagem(loginAcademiaMessage, 'CNPJ inválido.', 'error');
                return;
            }

            if (!senhaValor) {
                mostrarMensagem(loginAcademiaMessage, 'Informe sua senha.', 'error');
                return;
            }

            try {
                loginAcademiaBotao.disabled = true;
                loginAcademiaBotao.innerHTML = 'Entrando...';
                mostrarMensagem(loginAcademiaMessage, 'Verificando credenciais...', '');

                var response = await fetch(API_BASE_URL + '/api/auth/academias/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ cnpj: cnpjValor, senha: senhaValor })
                });

                if (!response.ok) {
                    var erroTexto = 'Credenciais da academia inválidas.';
                    try {
                        var erroBody = await response.json();
                        erroTexto = erroBody.message || erroBody.erro || erroBody.detail || erroTexto;
                    } catch (_) {}
                    mostrarMensagem(loginAcademiaMessage, erroTexto, 'error');
                    return;
                }

                var academia = await response.json();
                sessionStorage.setItem('socialpass_academia', JSON.stringify(academia));
                window.location.href = 'home.html';
            } catch (error) {
                mostrarMensagem(loginAcademiaMessage, error.message || 'Falha ao conectar com o servidor.', 'error');
            } finally {
                loginAcademiaBotao.disabled = false;
                loginAcademiaBotao.innerHTML = loginAcademiaBotaoHTML;
            }
        });
    }

    var homeNomeUsuario = document.getElementById('homeNomeUsuario');

    if (homeNomeUsuario) {
        if (!exigirLogin()) return;

        var sessao = obterSessao();
        homeNomeUsuario.textContent = sessao.nomeCompleto;

        var btnLogout = document.getElementById('btnLogout');
        if (btnLogout) {
            btnLogout.addEventListener('click', function (e) {
                e.preventDefault();
                encerrarSessao();
                window.location.href = 'login.html';
            });
        }

        if (typeof L !== 'undefined') {
            var mapa = L.map('mapaAcademias').setView([-22.9068, -43.1729], 12);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(mapa);
        }

        carregarAcademias();
    }

    async function carregarAcademias() {
        var container = document.getElementById('gymCarousel');
        var badgeTexto = document.getElementById('mapaBadgeTexto');

        if (!container) return;

        try {
            var response = await fetch(API_BASE_URL + '/api/academias');

            if (!response.ok) {
                throw new Error('Erro ao buscar academias.');
            }

            var academias = await response.json();

            if (badgeTexto) {
                badgeTexto.textContent = academias.length + ' academia(s) encontrada(s)';
            }

            if (academias.length === 0) {
                container.innerHTML = '<p style="padding: 16px; color: #777;">Nenhuma academia cadastrada ainda.</p>';
                return;
            }

            var diasLabel = {
                SEGUNDA_A_SEXTA: 'Seg a Sex',
                SEGUNDA_A_SABADO: 'Seg a Sáb',
                TODOS_OS_DIAS: 'Todos os dias'
            };

            container.innerHTML = academias.map(function (academia) {
                var atividades = academia.tipoAtividade && academia.tipoAtividade.length > 0
                    ? academia.tipoAtividade.join(' • ')
                    : 'Atividades diversas';

                var dias = diasLabel[academia.diasFuncionamento] || '';

                var horario = academia.horarioAbertura && academia.horarioFechamento
                    ? academia.horarioAbertura.substring(0, 5) + 'h às ' + academia.horarioFechamento.substring(0, 5) + 'h'
                    : '';

                var infoHorario = dias && horario ? dias + ', ' + horario : dias || horario;

                var vestiario = academia.possuiVestiario
                    ? '<p class="gym-status status-green" style="margin-top:2px;"><span class="material-symbols-rounded icon-sm">check_circle</span> Possui vestiário</p>'
                    : '';

                return (
                    '<div class="gym-card large">' +
                    '<div class="gym-cover large-cover">' +
                    '<span class="gym-tag">' +
                    '<span class="material-symbols-rounded icon-sm">fitness_center</span> ' +
                    escapeHtml(atividades) +
                    '</span>' +
                    '</div>' +
                    '<div class="gym-info">' +
                    '<h4 class="gym-name">' + escapeHtml(academia.nome) + '</h4>' +
                    '<p class="gym-address">' + escapeHtml(academia.endereco) + ' - ' + escapeHtml(academia.bairro) + '</p>' +
                    (infoHorario ? '<p class="gym-status status-green"><span class="material-symbols-rounded icon-sm">schedule</span> ' + escapeHtml(infoHorario) + '</p>' : '') +
                    vestiario +
                    '<button class="btn-outline">Ver detalhes</button>' +
                    '</div>' +
                    '</div>'
                );
            }).join('');
        } catch (error) {
            container.innerHTML = '<p style="padding: 16px; color: #b02a37;">Não foi possível carregar as academias. Verifique se o backend está rodando.</p>';
            if (badgeTexto) badgeTexto.textContent = 'Indisponível';
        }
    }

    var form = document.getElementById('cadastroForm');
    var mensagem = document.getElementById('formMessage');
    var botaoSubmit = form ? form.querySelector('.btn-submit') : null;
    var dataNascimentoInput = document.getElementById('dataNascimentoInput');

    if (dataNascimentoInput) {
        var hoje = new Date();
        dataNascimentoInput.setAttribute('max', hoje.toISOString().split('T')[0]);
    }

    if (form) {
        aplicarMascaraCPF(document.getElementById('cpfInput'));

        form.addEventListener('submit', async function (e) {
            e.preventDefault();

            var formData = new FormData(form);
            var nomeCompleto = (formData.get('nomeCompleto') || '').trim();
            var nomeUsuario = (formData.get('nomeUsuario') || '').trim();
            var cpf = limparNaoDigitos(formData.get('cpf'));
            var dataNascimento = formData.get('dataNascimento');
            var email = (formData.get('email') || '').trim();
            var telefone = limparNaoDigitos(formData.get('telefone'));
            var senha = (formData.get('senha') || '').trim();

            if (!nomeCompleto || nomeCompleto.length < 3) { mostrarToast('Informe um nome completo válido.', 'error'); return; }
            if (!validarNomeUsuario(nomeUsuario)) { mostrarToast('Nome de usuário inválido. Use 3 a 50 caracteres e sem espaços.', 'error'); return; }
            if (!validarCPF(cpf)) { mostrarToast('CPF inválido.', 'error'); return; }
            if (!validarEmail(email)) { mostrarToast('Email inválido.', 'error'); return; }
            if (!dataNascimento) { mostrarToast('Informe a data de nascimento.', 'error'); return; }
            if (!validarDataNascimento(dataNascimento)) { mostrarToast('Data de nascimento inválida. Use uma data existente e não futura.', 'error'); return; }
            if (!validarSenha(senha)) { mostrarToast('Senha deve ter no mínimo 4 caracteres, 1 letra maiúscula e 1 número.', 'error'); return; }

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
                if (botaoSubmit) botaoSubmit.disabled = true;
                mostrarMensagem(mensagem, 'Enviando cadastro...', '');

                var response = await fetch(API_BASE_URL + '/api/usuarios', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    var erroTexto = 'Erro ao cadastrar usuário.';
                    try {
                        var erroBody = await response.json();
                        erroTexto = erroBody.message || erroBody.erro || erroBody.detail || erroTexto;
                        if (erroBody.errors && Array.isArray(erroBody.errors)) {
                            erroTexto = erroBody.errors[0].defaultMessage || erroTexto;
                        }
                    } catch (err) {
                        try { var text = await response.text(); if (text) erroTexto = text; } catch (_) {}
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
                if (botaoSubmit) botaoSubmit.disabled = false;
            }
        });
    }
});