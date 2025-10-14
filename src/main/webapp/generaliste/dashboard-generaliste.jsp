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
    <title>Dashboard Généraliste - Système Médical</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        * { font-family: 'Inter', sans-serif; }
        .card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); }
        .stat-card { background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%); }
        .tab-button { transition: all 0.3s ease; }
        .tab-button.active { border-bottom: 3px solid #2563eb; color: #2563eb; background-color: #eff6ff; }
        .tab-content { display: none; animation: fadeIn 0.3s ease-in; }
        .tab-content.active { display: block; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .compact-card { padding: 1rem; border-left: 4px solid #10b981; }
        .compact-card:hover { background-color: #f9fafb; }
    </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-700 to-blue-900 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <h1 class="ml-3 text-xl font-bold text-white">Espace Médecin Généraliste</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-white">
                    <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    Dr. ${sessionScope.user}
                </span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="bg-white text-blue-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="mb-4 p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded">
                ${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="mb-4 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded">
                ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="stat-card rounded-xl p-6 text-white shadow-lg cursor-pointer" onclick="showTab('consultations')">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-white/80 text-sm font-medium">Total Consultations</p>
                    <p class="text-3xl font-bold mt-2">${totalConsultations}</p>
                </div>
                <svg class="h-12 w-12 text-white/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100 cursor-pointer hover:shadow-xl transition" onclick="showTab('consultations')">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">En cours</p>
                    <p class="text-3xl font-bold text-orange-600 mt-2">${consultationsEnCours}</p>
                </div>
                <svg class="h-12 w-12 text-orange-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100 cursor-pointer hover:shadow-xl transition" onclick="showTab('consultations')">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Terminées</p>
                    <p class="text-3xl font-bold text-green-600 mt-2">${consultationsTerminees}</p>
                </div>
                <svg class="h-12 w-12 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100 cursor-pointer hover:shadow-xl transition" onclick="showTab('expertises')">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Expertises</p>
                    <p class="text-3xl font-bold text-purple-600 mt-2">${totalDemandes}</p>
                    <c:if test="${not empty reponses}">
                        <p class="text-xs text-green-600 font-semibold mt-1">+${fn:length(reponses)} nouvelles</p>
                    </c:if>
                </div>
                <svg class="h-12 w-12 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Tabs Navigation -->
    <div class="bg-white rounded-xl shadow-lg mb-6">
        <div class="flex border-b border-gray-200">
            <button class="tab-button active flex-1 py-4 px-6 text-center font-semibold focus:outline-none"
                    onclick="showTab('consultations')" id="tab-consultations">
                <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Consultations (${consultationsEnCours})
            </button>
            <button class="tab-button flex-1 py-4 px-6 text-center font-semibold focus:outline-none"
                    onclick="showTab('expertises')" id="tab-expertises">
                <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Expertises Reçues (${fn:length(reponses)})
            </button>
            <button class="tab-button flex-1 py-4 px-6 text-center font-semibold focus:outline-none"
                    onclick="showTab('attente')" id="tab-attente">
                <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                En Attente (${fn:length(demandesEnAttente)})
            </button>
        </div>

        <!-- Tab Content: Consultations -->
        <div id="content-consultations" class="tab-content active p-6">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Patient</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Motif</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Statut</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <c:forEach items="${consultations}" var="consultation">
                        <tr class="hover:bg-gray-50 transition">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                        <span class="text-blue-700 font-bold">
                                                ${fn:substring(consultation.patient.prenom, 0, 1)}${fn:substring(consultation.patient.nom, 0, 1)}
                                        </span>
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900">
                                                ${consultation.patient.nom} ${consultation.patient.prenom}
                                        </div>
                                        <div class="text-sm text-gray-500">
                                                ${consultation.patient.dateNaissance}
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    ${fn:substring(consultation.dateConsultation.toString(), 0, 16)}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900">
                                    ${consultation.motif}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800">
                                    En cours
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="${pageContext.request.contextPath}/generaliste/consultation?patientId=${consultation.patient.id}"
                                   class="text-blue-600 hover:text-blue-900 inline-flex items-center">
                                    <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                    </svg>
                                    Consulter
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty consultations}">
                        <tr>
                            <td colspan="5" class="px-6 py-12 text-center text-gray-500">
                                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                </svg>
                                <p class="mt-2">Aucune consultation en cours</p>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Tab Content: Expertises Reçues (Compact View) -->
        <div id="content-expertises" class="tab-content p-6">
            <div class="space-y-3">
                <c:forEach items="${reponses}" var="demande" varStatus="status">
                    <div class="compact-card bg-white border rounded-lg shadow-sm hover:shadow-md transition cursor-pointer"
                         onclick="window.location.href='${pageContext.request.contextPath}/generaliste/voir-expertise?demandeId=${demande.id}'">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4 flex-1">
                                <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                                    <svg class="w-5 h-5 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                    </svg>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center space-x-2">
                                        <h3 class="text-sm font-bold text-gray-900 truncate">
                                            Dr. ${demande.specialiste.nom} ${demande.specialiste.prenom}
                                        </h3>
                                        <span class="px-2 py-0.5 bg-green-100 text-green-800 text-xs font-semibold rounded-full">
                                            ✓ Répondu
                                        </span>
                                    </div>
                                    <p class="text-xs text-gray-600 truncate">
                                            ${not empty demande.specialiste.specialite ? demande.specialiste.specialite.nom : 'Spécialiste'} •
                                        Patient #${demande.consultation.patient.id}
                                    </p>
                                    <p class="text-xs text-gray-500 mt-1 truncate">
                                            ${fn:substring(demande.avisMedical, 0, 80)}...
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-2 ml-4">
                                <span class="text-xs text-gray-500 whitespace-nowrap">
                                        ${fn:substring(demande.dateReponse.toString(), 0, 16)}
                                </span>
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty reponses}">
                    <div class="text-center py-12 text-gray-500">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                        </svg>
                        <p class="mt-2">Aucune expertise reçue</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Tab Content: En Attente (Compact View) -->
        <div id="content-attente" class="tab-content p-6">
            <div class="space-y-3">
                <c:forEach items="${demandesEnAttente}" var="demande">
                    <div class="compact-card bg-white border rounded-lg shadow-sm" style="border-left-color: #f59e0b;">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4 flex-1">
                                <div class="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center flex-shrink-0">
                                    <svg class="w-5 h-5 text-orange-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center space-x-2">
                                        <h3 class="text-sm font-bold text-gray-900 truncate">
                                            Dr. ${demande.specialiste.nom} ${demande.specialiste.prenom}
                                        </h3>
                                        <span class="px-2 py-0.5 bg-yellow-100 text-yellow-800 text-xs font-semibold rounded-full">
                                            ⏳ En attente
                                        </span>
                                    </div>
                                    <p class="text-xs text-gray-600 truncate">
                                            ${not empty demande.specialiste.specialite ? demande.specialiste.specialite.nom : 'Spécialiste'} •
                                        Patient #${demande.consultation.patient.id}
                                    </p>
                                    <p class="text-xs text-gray-500 mt-1 truncate">
                                            ${fn:substring(demande.question, 0, 80)}...
                                    </p>
                                </div>
                            </div>
                            <div class="text-xs text-gray-500 whitespace-nowrap ml-4">
                                    ${fn:substring(demande.dateDemande.toString(), 0, 16)}
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty demandesEnAttente}">
                    <div class="text-center py-12 text-gray-500">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <p class="mt-2">Aucune demande en attente</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function showTab(tabName) {
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.querySelectorAll('.tab-button').forEach(button => {
            button.classList.remove('active');
        });

        // Show selected tab
        document.getElementById('content-' + tabName).classList.add('active');
        document.getElementById('tab-' + tabName).classList.add('active');
    }
</script>

</body>
</html>