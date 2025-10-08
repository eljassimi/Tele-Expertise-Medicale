<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || session.getAttribute("user") == null ||
            !"INFIRMIER".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Infirmier - Système Médical</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        * {
            font-family: 'Inter', sans-serif;
        }

        .card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-card {
            background: linear-gradient(135deg, #146c5c 0%, #0f5449 100%);
        }

        .badge-waiting {
            background-color: #fef3c7;
            color: #92400e;
        }

        .badge-done {
            background-color: #d1fae5;
            color: #065f46;
        }
    </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-teal-700 to-teal-900 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <h1 class="ml-3 text-xl font-bold text-white">Espace Infirmier</h1>
            </div>

            <div class="flex items-center space-x-4">
                    <span class="text-white">
                        <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        ${sessionScope.user}
                    </span>
                <a href="logout" class="bg-white text-teal-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="stat-card rounded-xl p-6 text-white shadow-lg">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-white/80 text-sm font-medium">Patients du jour</p>
                    <p class="text-3xl font-bold mt-2">${patientsCount}</p>
                </div>
                <svg class="h-12 w-12 text-white/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">En attente</p>
                    <p class="text-3xl font-bold text-yellow-600 mt-2">${enAttenteCount}</p>
                </div>
                <svg class="h-12 w-12 text-yellow-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Consultés</p>
                    <p class="text-3xl font-bold text-green-600 mt-2">${consultesCount}</p>
                </div>
                <svg class="h-12 w-12 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Actions rapides -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <a href="accueil-patient.jsp" class="card bg-white rounded-xl p-6 shadow-lg border-2 border-transparent hover:border-teal-500">
            <div class="flex items-center">
                <div class="bg-teal-100 rounded-lg p-3">
                    <svg class="h-8 w-8 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                    </svg>
                </div>
                <div class="ml-4">
                    <h3 class="text-lg font-bold text-gray-900">Accueillir un patient</h3>
                    <p class="text-sm text-gray-600 mt-1">Enregistrer ou rechercher un patient</p>
                </div>
            </div>
        </a>

        <a href="infirmier/liste-patients" class="card bg-white rounded-xl p-6 shadow-lg border-2 border-transparent hover:border-teal-500">
            <div class="flex items-center">
                <div class="bg-blue-100 rounded-lg p-3">
                    <svg class="h-8 w-8 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                    </svg>
                </div>
                <div class="ml-4">
                    <h3 class="text-lg font-bold text-gray-900">Liste des patients</h3>
                    <p class="text-sm text-gray-600 mt-1">Voir tous les patients enregistrés</p>
                </div>
            </div>
        </a>
    </div>

    <!-- Liste des patients récents -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <h2 class="text-xl font-bold text-gray-900">Patients récents</h2>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Patient
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        N° Sécurité Sociale
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Heure d'arrivée
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Signes vitaux
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Statut
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <c:forEach items="${patients}" var="patient">
                    <tr class="hover:bg-gray-50 transition">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10 bg-teal-100 rounded-full flex items-center justify-center">
                                            <span class="text-teal-700 font-semibold">
                                                    ${patient.prenom.substring(0,1)}${patient.nom.substring(0,1)}
                                            </span>
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900">
                                            ${patient.nom} ${patient.prenom}
                                    </div>
                                    <div class="text-sm text-gray-500">
                                        <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                ${patient.numeroSecuriteSociale}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            <fmt:formatDate value="${patient.dateEnregistrement}" pattern="HH:mm"/>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-500">
                            <c:if test="${not empty patient.signesVitaux}">
                                <c:set var="dernierSigne" value="${patient.signesVitaux[patient.signesVitaux.size()-1]}"/>
                                <div class="space-y-1">
                                    <div>TA: ${dernierSigne.tensionArterielle}</div>
                                    <div>FC: ${dernierSigne.frequenceCardiaque} bpm</div>
                                    <div>T°: ${dernierSigne.temperature}°C</div>
                                </div>
                            </c:if>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <c:choose>
                                <c:when test="${patient.enAttente}">
                                            <span class="badge-waiting px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                                En attente
                                            </span>
                                </c:when>
                                <c:otherwise>
                                            <span class="badge-done px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                                Consulté
                                            </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <a href="infirmier/patient/${patient.id}"
                               class="text-teal-600 hover:text-teal-900 mr-3">
                                Voir détails
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty patients}">
                    <tr>
                        <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                            </svg>
                            <p class="mt-2">Aucun patient enregistré aujourd'hui</p>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
