(function () {
    const STORAGE_KEY = "socialpass_academia";

    function formatHorario(acad) {
        if (acad.horarioFuncionamento) return acad.horarioFuncionamento;
        if (acad.horarioAbertura && acad.horarioFechamento) {
            return acad.horarioAbertura + " - " + acad.horarioFechamento;
        }
        return "-";
    }

    function mockStats() {
        return {
            checkinsHoje: 47,
            ativosMes: 389,
            ocupacaoAgora: 62,
            matriculasSemana: 18
        };
    }

    function loadAcademia() {
        const raw = sessionStorage.getItem(STORAGE_KEY);
        if (!raw) return null;
        try {
            return JSON.parse(raw);
        } catch (e) {
            return null;
        }
    }

    function preencherTela(acad) {
        const stats = mockStats();

        document.getElementById("academyName").textContent = acad.nome || "Academia";
        document.getElementById("academyCnpj").textContent = acad.cnpj || "-";
        document.getElementById("academyEmail").textContent = acad.email || "-";
        document.getElementById("academyPhone").textContent = acad.telefone || "-";
        document.getElementById("academyAddress").textContent = acad.endereco || "-";
        document.getElementById("academyBairro").textContent = acad.bairro || "-";
        document.getElementById("academyCep").textContent = acad.cep || "-";
        document.getElementById("academyDias").textContent = acad.diasFuncionamento || "-";
        document.getElementById("academyHorario").textContent = formatHorario(acad);
        document.getElementById("academyStatus").textContent = acad.status || "-";
        document.getElementById("academyVestiario").textContent = acad.possuiVestiario ? "Sim" : "Nao";

        document.getElementById("kpiCheckins").textContent = String(stats.checkinsHoje);
        document.getElementById("kpiAtivos").textContent = String(stats.ativosMes);
        document.getElementById("kpiOcupacao").textContent = stats.ocupacaoAgora + "%";
        document.getElementById("kpiMatriculas").textContent = String(stats.matriculasSemana);
    }

    function bindEventos() {
        document.getElementById("btnLogout").addEventListener("click", function () {
            sessionStorage.removeItem(STORAGE_KEY);
            window.location.href = "index.html";
        });

        document.getElementById("btnRefresh").addEventListener("click", function () {
            window.location.reload();
        });
    }

    const academia = loadAcademia();
    if (!academia) {
        window.location.href = "cadastroacademia.html";
        return;
    }

    preencherTela(academia);
    bindEventos();
})();