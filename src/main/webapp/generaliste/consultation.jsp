<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    if (session == null || session.getAttribute("user") == null ||
            !"GENERALISTE".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultation Patient - Télé-expertise Médicale</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        * { font-family: 'Inter', sans-serif; }
        .input-field { transition: all 0.3s ease; }
        .input-field:focus { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15); }
    </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-700 to-blue-900 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
                   class="text-white hover:text-gray-200 mr-4">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                </a>
                <h1 class="text-xl font-bold text-white">Consultation Patient</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-white">Dr. ${sessionScope.user}</span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="bg-white text-blue-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Messages d'erreur/succès -->
    <c:if test="${not empty sessionScope.error}">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-4">
                ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Informations patient -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
            <svg class="w-6 h-6 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            Informations du patient
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <p class="text-sm text-gray-600">Nom complet</p>
                <p class="font-semibold text-lg">${patient.nom} ${patient.prenom}</p>
            </div>
            <div>
                <p class="text-sm text-gray-600">Date de naissance</p>
                <p class="font-semibold">${patient.dateNaissance}</p>
            </div>
            <div>
                <p class="text-sm text-gray-600">N° Sécurité Sociale</p>
                <p class="font-semibold">${patient.numeroSecuriteSociale}</p>
            </div>
        </div>

        <!-- Signes vitaux -->
        <c:if test="${not empty patient.signesVitaux and fn:length(patient.signesVitaux) > 0}">
            <div class="mt-4 pt-4 border-t">
                <h3 class="text-sm font-semibold text-gray-700 mb-2">Signes vitaux récents</h3>
                <c:forEach items="${patient.signesVitaux}" var="signe" varStatus="status">
                    <c:if test="${status.last}">
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                            <div class="bg-blue-50 rounded-lg p-3">
                                <p class="text-xs text-blue-600">Tension artérielle</p>
                                <p class="font-semibold">${signe.tensionArterielle}</p>
                            </div>
                            <div class="bg-red-50 rounded-lg p-3">
                                <p class="text-xs text-red-600">Fréquence cardiaque</p>
                                <p class="font-semibold">${signe.frequenceCardiaque} bpm</p>
                            </div>
                            <div class="bg-orange-50 rounded-lg p-3">
                                <p class="text-xs text-orange-600">Température</p>
                                <p class="font-semibold">${signe.temperature}°C</p>
                            </div>
                            <div class="bg-green-50 rounded-lg p-3">
                                <p class="text-xs text-green-600">Fréquence respiratoire</p>
                                <p class="font-semibold">${signe.frequenceRespiratoire}/min</p>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>

        <!-- Antécédents et allergies -->
        <c:if test="${not empty patient.antecedents || not empty patient.allergies}">
            <div class="mt-4 pt-4 border-t">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <c:if test="${not empty patient.antecedents}">
                        <div>
                            <p class="text-sm font-semibold text-gray-700 mb-1">Antécédents médicaux</p>
                            <p class="text-sm text-gray-600 bg-gray-50 p-2 rounded">${patient.antecedents}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty patient.allergies}">
                        <div>
                            <p class="text-sm font-semibold text-red-700 mb-1 flex items-center">
                                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                                </svg>
                                Allergies
                            </p>
                            <p class="text-sm text-red-600 bg-red-50 p-2 rounded font-medium">${patient.allergies}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Formulaire de consultation -->
    <form id="consultationForm" method="post">
        <input type="hidden" name="patientId" value="${patient.id}"/>
        <input type="hidden" name="action" id="actionField" value=""/>

        <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <svg class="w-6 h-6 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Détails de la consultation
            </h2>

            <div class="space-y-6">
                <!-- Motif -->
                <div>
                    <label for="motif" class="block text-sm font-semibold text-gray-700 mb-2">
                        Motif de consultation <span class="text-red-500">*</span>
                    </label>
                    <textarea
                            id="motif"
                            name="motif"
                            required
                            rows="3"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                            placeholder="Ex: Douleurs thoraciques, toux persistante, fièvre..."></textarea>
                </div>

                <!-- Observations -->
                <div>
                    <label for="observations" class="block text-sm font-semibold text-gray-700 mb-2">
                        Observations cliniques (Examen physique) <span class="text-red-500">*</span>
                    </label>
                    <textarea
                            id="observations"
                            name="observations"
                            required
                            rows="5"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                            placeholder="Examen clinique détaillé : auscultation, palpation, inspection..."></textarea>
                    <p class="text-xs text-gray-500 mt-1">L'examen physique effectué sur le patient</p>
                </div>

                <!-- Diagnostic -->
                <div>
                    <label for="diagnostic" class="block text-sm font-semibold text-gray-700 mb-2">
                        Diagnostic
                        <span class="text-red-500" id="diagnosticRequired" style="display: none;">*</span>
                    </label>
                    <textarea
                            id="diagnostic"
                            name="diagnostic"
                            rows="3"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                            placeholder="Maladie identifiée (requis pour clôturer la consultation)"></textarea>
                    <p class="text-xs text-gray-500 mt-1">La maladie identifiée par le médecin</p>
                </div>

                <!-- Traitement -->
                <div>
                    <label for="traitement" class="block text-sm font-semibold text-gray-700 mb-2">
                        Traitement prescrit
                        <span class="text-red-500" id="traitementRequired" style="display: none;">*</span>
                    </label>
                    <textarea
                            id="traitement"
                            name="traitement"
                            rows="4"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                            placeholder="Ex: &#10;- Paracétamol 1g, 3 fois/jour&#10;- Sirop antitussif, 2 cuillères/jour&#10;&#10;(Requis pour clôturer la consultation)"></textarea>
                    <p class="text-xs text-gray-500 mt-1">Les médicaments prescrits avec posologie</p>
                </div>

                <!-- Actes techniques -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-3">
                        Actes techniques médicaux effectués
                    </label>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                        <c:forEach items="${actesTechniques}" var="acte">
                            <label class="flex items-center space-x-2 p-3 border-2 border-gray-200 rounded-lg hover:border-blue-500 cursor-pointer transition">
                                <input type="checkbox" name="actesTechniques" value="${acte}" class="w-4 h-4 text-blue-600 rounded" onchange="calculateCost()">
                                <span class="text-sm">${acte.libelle}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Résumé des coûts (US4) -->
        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl shadow-lg p-6 mb-6 border-2 border-blue-200">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Résumé des coûts
            </h3>
            <div class="space-y-2">
                <div class="flex justify-between items-center">
                    <span class="text-gray-700">Consultation généraliste</span>
                    <span class="font-semibold text-gray-900">150.00 DH</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-gray-700">Actes techniques</span>
                    <span class="font-semibold text-gray-900" id="coutActes">0.00 DH</span>
                </div>
                <div class="border-t-2 border-blue-300 pt-2 flex justify-between items-center text-lg">
                    <span class="font-bold text-gray-900">Total actuel</span>
                    <span class="font-bold text-blue-700 text-xl" id="coutTotal">150.00 DH</span>
                </div>
                <p class="text-xs text-gray-600 mt-2">
                    <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    Le coût de l'expertise s'ajoutera si un avis spécialiste est demandé
                </p>
            </div>
        </div>

        <!-- Actions : Deux scénarios possibles -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Décision de prise en charge</h3>

            <!-- Info Box -->
            <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
                <p class="text-sm text-blue-900">
                    <strong>Scénario A :</strong> Si vous pouvez gérer la situation, clôturez la consultation directement.<br>
                    <strong>Scénario B :</strong> Si vous avez besoin de l'avis d'un spécialiste, demandez une expertise.
                </p>
            </div>

            <div class="flex flex-col sm:flex-row justify-end space-y-3 sm:space-y-0 sm:space-x-4">
                <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
                   class="bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-300 transition text-center">
                    <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                    Annuler
                </a>

                <!-- Scénario B : Demander avis spécialiste -->
                <button type="button"
                        onclick="demanderAvis()"
                        class="bg-orange-500 text-white px-6 py-3 rounded-xl font-semibold hover:bg-orange-600 transition">
                    <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z"/>
                    </svg>
                    Demander avis spécialiste
                </button>

                <!-- Scénario A : Clôturer directement -->
                <button type="button"
                        onclick="cloturerConsultation()"
                        class="bg-green-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-green-700 transition">
                    <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    Enregistrer et clôturer
                </button>
            </div>
        </div>
    </form>
</div>

<script>
    // Coûts des actes techniques
    const coutActesMap = {
        'RADIOGRAPHIE': 200,
        'ECHOGRAPHIE': 300,
        'IRM': 800,
        'ELECTROCARDIOGRAMME': 150,
        'DERMATOLOGIQUE_LASER': 400,
        'FOND_OEIL': 180,
        'ANALYSE_SANG': 120,
        'ANALYSE_URINE': 80
    };

    // Calcul du coût total (US4 avec Lambda expression en frontend)
    function calculateCost() {
        let totalActes = 0;
        document.querySelectorAll('input[name="actesTechniques"]:checked').forEach(checkbox => {
            totalActes += coutActesMap[checkbox.value] || 0;
        });

        document.getElementById('coutActes').textContent = totalActes.toFixed(2) + ' DH';

        const coutConsultation = 150;
        const total = coutConsultation + totalActes;
        document.getElementById('coutTotal').textContent = total.toFixed(2) + ' DH';
    }

    // Scénario A : Clôturer la consultation
    function cloturerConsultation() {
        const diagnostic = document.getElementById('diagnostic').value.trim();
        const traitement = document.getElementById('traitement').value.trim();

        if (!diagnostic || !traitement) {
            alert('⚠️ Pour clôturer la consultation, le diagnostic et le traitement sont obligatoires.');
            // Marquer visuellement les champs requis
            document.getElementById('diagnosticRequired').style.display = 'inline';
            document.getElementById('traitementRequired').style.display = 'inline';
            document.getElementById('diagnostic').classList.add('border-red-500');
            document.getElementById('traitement').classList.add('border-red-500');
            return;
        }

        if (confirm('Êtes-vous sûr de vouloir clôturer cette consultation ? Cette action est définitive.')) {
            document.getElementById('actionField').value = 'cloturer';
            document.getElementById('consultationForm').action = '${pageContext.request.contextPath}/generaliste/consultation';
            document.getElementById('consultationForm').submit();
        }
    }

    // Scénario B : Demander avis spécialiste
    function demanderAvis() {
        const motif = document.getElementById('motif').value.trim();
        const observations = document.getElementById('observations').value.trim();

        if (!motif || !observations) {
            alert('⚠️ Le motif et les observations sont requis avant de demander un avis spécialiste.');
            return;
        }

        if (confirm('Souhaitez-vous demander l\'avis d\'un spécialiste pour ce patient ?')) {
            document.getElementById('actionField').value = 'demander_avis';
            document.getElementById('consultationForm').action = '${pageContext.request.contextPath}/generaliste/consultation';
            document.getElementById('consultationForm').submit();
        }
    }

    // Retirer les marqueurs d'erreur quand l'utilisateur saisit
    document.getElementById('diagnostic').addEventListener('input', function() {
        this.classList.remove('border-red-500');
        document.getElementById('diagnosticRequired').style.display = 'none';
    });

    document.getElementById('traitement').addEventListener('input', function() {
        this.classList.remove('border-red-500');
        document.getElementById('traitementRequired').style.display = 'none';
    });
</script>

</body>
</html>