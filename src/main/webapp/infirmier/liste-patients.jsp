<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Liste des Patients - Système Médical</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        * {
            font-family: 'Inter', sans-serif;
        }

        .badge-waiting {
            background-color: #fef3c7;
            color: #92400e;
        }

        .badge-done {
            background-color: #d1fae5;
            color: #065f46;
        }

        tr:hover {
            background-color: #f9fafb;
        }
    </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-teal-700 to-teal-900 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/infirmier/dashboard-infirmier"
                   class="text-white hover:text-gray-200 mr-4">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                </a>
                <h1 class="text-xl font-bold text-white">Liste des Patients</h1>
            </div>
            <div class="flex items-center space-x-4">
                    <span class="text-white">
                        <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        ${sessionScope.user}
                    </span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="bg-white text-teal-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- En-tête avec statistiques -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <h2 class="text-2xl font-bold text-gray-900">Patients du jour</h2>
                <p class="text-gray-600 mt-1">
                    <span class="font-semibold text-teal-700">${fn:length(patients)}</span> patients enregistrés aujourd'hui
                </p>
            </div>

            <!-- Filtres -->
            <div class="flex flex-wrap gap-3">
                <form method="get" class="flex gap-3">
                    <select name="statut" onchange="this.form.submit()"
                            class="px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-teal-700">
                        <option value="">Tous les statuts</option>
                        <option value="EN_ATTENTE" ${param.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                        <option value="CONSULTE" ${param.statut == 'CONSULTE' ? 'selected' : ''}>Consulté</option>
                    </select>

                    <input type="date"
                           name="date"
                           value="${param.date}"
                           onchange="this.form.submit()"
                           class="px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-teal-700">
                </form>

                <a href="${pageContext.request.contextPath}/infirmier/accueil-patient"
                   class="bg-teal-700 text-white px-4 py-2 rounded-lg hover:bg-teal-800 transition font-semibold inline-flex items-center">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Nouveau patient
                </a>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty success}">
        <div class="mb-4 p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded">
            <div class="flex items-center">
                <svg class="h-5 w-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                </svg>
                    ${success}
            </div>
        </div>
    </c:if>

    <!-- Tableau des patients -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Patient
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Informations
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Heure d'arrivée
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Signes vitaux
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Statut
                    </th>
                    <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <c:forEach items="${patients}" var="patient">
                    <tr class="transition">
                        <!-- Colonne Patient -->
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-12 w-12 bg-teal-100 rounded-full flex items-center justify-center">
                                            <span class="text-teal-700 font-bold text-lg">
                                                <c:choose>
                                                    <c:when test="${fn:length(patient.prenom) > 0 and fn:length(patient.nom) > 0}">
                                                        ${fn:substring(patient.prenom, 0, 1)}${fn:substring(patient.nom, 0, 1)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ?
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-bold text-gray-900">
                                            ${patient.nom} ${patient.prenom}
                                    </div>
                                    <div class="text-xs text-gray-500">
                                        Né(e) le ${patient.dateNaissance}
                                    </div>
                                </div>
                            </div>
                        </td>

                        <!-- Colonne Informations -->
                        <td class="px-6 py-4">
                            <div class="text-sm">
                                <div class="text-gray-900 font-medium">
                                    SS: ${patient.numeroSecuriteSociale}
                                </div>
                                <c:if test="${not empty patient.telephone}">
                                    <div class="text-gray-500 flex items-center mt-1">
                                        <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                                        </svg>
                                            ${patient.telephone}
                                    </div>
                                </c:if>
                                <c:if test="${not empty patient.mutuelle}">
                                    <div class="text-gray-500 text-xs mt-1">
                                        Mutuelle: ${patient.mutuelle}
                                    </div>
                                </c:if>
                            </div>
                        </td>

                        <!-- Colonne Heure d'arrivée -->
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center text-sm text-gray-900">
                                <svg class="h-5 w-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <c:if test="${not empty patient.dateEnregistrement}">
                                    ${fn:substring(patient.dateEnregistrement.toLocalTime().toString(), 0, 5)}
                                </c:if>
                            </div>
                        </td>

                        <!-- Colonne Signes vitaux -->
                        <td class="px-6 py-4 text-sm">
                            <c:choose>
                                <c:when test="${not empty patient.signesVitaux and fn:length(patient.signesVitaux) > 0}">
                                    <c:forEach items="${patient.signesVitaux}" var="signe" varStatus="status">
                                        <c:if test="${status.last}">
                                            <div class="grid grid-cols-2 gap-2 text-xs">
                                                <c:if test="${not empty signe.tensionArterielle}">
                                                    <div class="bg-blue-50 px-2 py-1 rounded">
                                                        <span class="text-blue-700 font-semibold">TA:</span>
                                                        <span class="text-gray-900">${signe.tensionArterielle}</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty signe.frequenceCardiaque}">
                                                    <div class="bg-red-50 px-2 py-1 rounded">
                                                        <span class="text-red-700 font-semibold">FC:</span>
                                                        <span class="text-gray-900">${signe.frequenceCardiaque} bpm</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty signe.temperature}">
                                                    <div class="bg-orange-50 px-2 py-1 rounded">
                                                        <span class="text-orange-700 font-semibold">T°:</span>
                                                        <span class="text-gray-900">${signe.temperature}°C</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty signe.frequenceRespiratoire}">
                                                    <div class="bg-green-50 px-2 py-1 rounded">
                                                        <span class="text-green-700 font-semibold">FR:</span>
                                                        <span class="text-gray-900">${signe.frequenceRespiratoire}/min</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-400 text-xs italic">Aucun signe vital</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Colonne Statut -->
                        <td class="px-6 py-4 whitespace-nowrap">
                            <c:choose>
                                <c:when test="${patient.enAttente}">
                                            <span class="badge-waiting px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                                <svg class="h-4 w-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
                                                </svg>
                                                En attente
                                            </span>
                                </c:when>
                                <c:otherwise>
                                            <span class="badge-done px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                                <svg class="h-4 w-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                                </svg>
                                                Consulté
                                            </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Colonne Actions -->
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <a href="${pageContext.request.contextPath}/infirmier/patient/${patient.id}"
                               class="text-teal-600 hover:text-teal-900 inline-flex items-center">
                                <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                                Voir détails
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- Message si vide -->
            <c:if test="${empty patients}">
                <div class="text-center py-12">
                    <svg class="mx-auto h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                    </svg>
                    <h3 class="mt-4 text-lg font-medium text-gray-900">Aucun patient trouvé</h3>
                    <p class="mt-2 text-sm text-gray-500">Commencez par enregistrer un nouveau patient</p>
                    <div class="mt-6">
                        <a href="${pageContext.request.contextPath}/infirmier/accueil-patient"
                           class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-teal-600 hover:bg-teal-700">
                            <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                            </svg>
                            Nouveau patient
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Pagination (optionnelle) -->
    <c:if test="${not empty patients and fn:length(patients) > 0}">
        <div class="mt-6 flex justify-between items-center">
            <div class="text-sm text-gray-700">
                Affichage de <span class="font-medium">${fn:length(patients)}</span> patients
            </div>
        </div>
    </c:if>
</div>

</body>
</html>
