<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session == null || session.getAttribute("user") == null ||
            !"SPECIALISTE".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Répondre à l'Expertise</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        * { font-family: 'Inter', sans-serif; }
        .mode-card { cursor: pointer; border: 3px solid transparent; transition: all 0.3s; }
        .mode-card:hover { transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,0.15); }
        .mode-card.selected { border-color: #7c3aed; background-color: #f5f3ff; }
        #formEcrite, #formTelephone { display: none; }
    </style>
</head>
<body class="bg-gray-50">

<nav class="bg-gradient-to-r from-purple-700 to-purple-900 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
        <a href="${pageContext.request.contextPath}/specialiste/dashboard-specialiste" class="text-white hover:text-gray-200">
            <svg class="h-6 w-6 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
            </svg>
            <span class="ml-2 text-xl font-bold">Répondre à l'Expertise</span>
        </a>
        <span class="text-white">Dr. ${sessionScope.user}</span>
    </div>
</nav>

<div class="max-w-5xl mx-auto px-4 py-8">

    <c:if test="${not empty sessionScope.error}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Patient Info -->
    <div class="bg-white rounded-xl shadow p-6 mb-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold">Demande d'Expertise</h2>
            <c:choose>
                <c:when test="${demande.priorite eq 'URGENTE'}">
                    <span class="px-4 py-2 bg-red-100 text-red-700 rounded-full font-bold">🔴 URGENTE</span>
                </c:when>
                <c:when test="${demande.priorite eq 'NORMALE'}">
                    <span class="px-4 py-2 bg-blue-100 text-blue-700 rounded-full font-bold">🔵 NORMALE</span>
                </c:when>
                <c:otherwise>
                    <span class="px-4 py-2 bg-gray-100 text-gray-700 rounded-full font-bold">⚪ NON URGENTE</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4">
            <div class="bg-purple-50 p-4 rounded-lg">
                <p class="text-sm text-gray-600">Patient</p>
                <p class="font-bold">Patient #${demande.consultation.patient.id}</p>
            </div>
            <div class="bg-purple-50 p-4 rounded-lg">
                <p class="text-sm text-gray-600">Motif</p>
                <p class="font-bold">${demande.consultation.motif}</p>
            </div>
        </div>

        <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded">
            <p class="font-semibold mb-2">Question du Généraliste:</p>
            <p class="text-gray-800">${demande.question}</p>
        </div>

        <c:if test="${not empty demande.donneesAnalyses}">
            <div class="bg-gray-50 p-4 rounded mt-4">
                <p class="font-semibold mb-2">Données complémentaires:</p>
                <p class="text-gray-800 whitespace-pre-wrap">${demande.donneesAnalyses}</p>
            </div>
        </c:if>
    </div>

    <!-- Mode Selection -->
    <div class="bg-white rounded-xl shadow p-6 mb-6">
        <h2 class="text-xl font-bold mb-4">Choisissez le mode de réponse</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Written Response -->
            <div class="mode-card bg-white border-2 rounded-xl p-6" onclick="selectMode('ECRITE')">
                <input type="radio" name="mode" value="ECRITE" id="modeEcrite" class="hidden"/>
                <div class="text-center">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-blue-100 rounded-full mb-4">
                        <svg class="w-10 h-10 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-bold mb-2">Réponse Écrite</h3>
                    <p class="text-sm text-gray-600">Rédiger un avis médical détaillé avec recommandations</p>
                </div>
            </div>

            <!-- Phone Response -->
            <div class="mode-card bg-white border-2 rounded-xl p-6" onclick="selectMode('TELEPHONIQUE')">
                <input type="radio" name="mode" value="TELEPHONIQUE" id="modeTelephone" class="hidden"/>
                <div class="text-center">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-green-100 rounded-full mb-4">
                        <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                        </svg>
                    </div>
                    <h3 class="text-lg font-bold mb-2">Réponse Téléphonique</h3>
                    <p class="text-sm text-gray-600">Appeler le généraliste directement pour discuter du cas</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Written Response Form -->
    <div id="formEcrite">
        <form method="post" action="${pageContext.request.contextPath}/specialiste/repondre-expertise">
            <input type="hidden" name="demandeId" value="${demande.id}"/>
            <input type="hidden" name="modeReponse" value="ECRITE"/>

            <div class="bg-white rounded-xl shadow p-6 mb-6">
                <h2 class="text-xl font-bold mb-4">Votre Avis Médical Écrit</h2>

                <div class="space-y-4">
                    <div>
                        <label class="block font-semibold mb-2">Avis Médical <span class="text-red-500">*</span></label>
                        <textarea name="avisMedical" required rows="8"
                                  class="w-full px-4 py-3 border-2 rounded-lg focus:border-purple-600"
                                  placeholder="Votre diagnostic, analyse et opinion médicale..."></textarea>
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Recommandations</label>
                        <textarea name="recommandations" rows="6"
                                  class="w-full px-4 py-3 border-2 rounded-lg focus:border-purple-600"
                                  placeholder="Recommandations thérapeutiques, examens complémentaires..."></textarea>
                    </div>

                    <div class="bg-purple-50 p-4 rounded-lg">
                        <p class="text-lg">Honoraires: <span class="font-bold text-purple-700">${specialiste.tarif} DH</span></p>
                    </div>

                    <div class="flex justify-end gap-4">
                        <a href="${pageContext.request.contextPath}/specialiste/dashboard-specialiste"
                           class="px-6 py-3 bg-gray-200 rounded-lg hover:bg-gray-300">Annuler</a>
                        <button type="submit" class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700">
                            Envoyer l'Avis
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Phone Response Form -->
    <div id="formTelephone">
        <div class="bg-white rounded-xl shadow p-6 mb-6">
            <h2 class="text-xl font-bold mb-4">Réponse Téléphonique</h2>

            <!-- Generaliste Contact Info -->
            <div class="bg-green-50 border-2 border-green-500 rounded-xl p-6 mb-6">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="text-lg font-bold text-gray-900">Médecin Généraliste</h3>
                        <p class="text-gray-700">
                            Dr. ${demande.consultation.medecinGeneraliste.nom} ${demande.consultation.medecinGeneraliste.prenom}
                        </p>
                    </div>
                    <svg class="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                </div>

                <c:choose>
                    <c:when test="${not empty demande.consultation.medecinGeneraliste.telephone}">
                        <div class="bg-white rounded-lg p-4 mb-4">
                            <p class="text-sm text-gray-600 mb-2">Numéro de téléphone</p>
                            <p class="text-sm text-gray-600 mb-2">${demande.consultation.medecinGeneraliste.telephone}</p>
<%--                            <a href="tel:${demande.consultation.medecinGeneraliste.telephone}"--%>
<%--                               class="text-3xl font-bold text-green-600 hover:text-green-700">--%>
<%--                                    ${demande.consultation.medecinGeneraliste.telephone}--%>
<%--                            </a>--%>
                        </div>

                        <a href="tel:${demande.consultation.medecinGeneraliste.telephone}"
                           class="block w-full bg-green-600 text-white text-center py-4 rounded-lg font-bold hover:bg-green-700 transition">
                            <svg class="w-6 h-6 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                            Appeler Maintenant <span>${demande.consultation.medecinGeneraliste.telephone}</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-yellow-100 border-l-4 border-yellow-500 p-4">
                            <p class="text-yellow-800">Numéro de téléphone non disponible pour ce généraliste</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty demande.consultation.medecinGeneraliste.email}">
                    <div class="mt-4">
                        <p class="text-sm text-gray-600">Email</p>
                        <a href="mailto:${demande.consultation.medecinGeneraliste.email}"
                           class="text-blue-600 hover:underline">
                                ${demande.consultation.medecinGeneraliste.email}
                        </a>
                    </div>
                </c:if>
            </div>

            <!-- After Call Notes -->
            <form method="post" action="${pageContext.request.contextPath}/specialiste/repondre-expertise">
                <input type="hidden" name="demandeId" value="${demande.id}"/>
                <input type="hidden" name="modeReponse" value="TELEPHONIQUE"/>

                <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-4">
                    <p class="text-sm text-blue-900">
                        <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        Après l'appel, résumez brièvement les points discutés pour le dossier médical
                    </p>
                </div>

                <div class="mb-4">
                    <label class="block font-semibold mb-2">Résumé de l'Appel <span class="text-red-500">*</span></label>
                    <textarea name="avisMedical" required rows="6"
                              class="w-full px-4 py-3 border-2 rounded-lg focus:border-green-600"
                              placeholder="Points principaux discutés lors de l'appel téléphonique..."></textarea>
                </div>

                <div class="mb-4">
                    <label class="block font-semibold mb-2">Recommandations</label>
                    <textarea name="recommandations" rows="4"
                              class="w-full px-4 py-3 border-2 rounded-lg focus:border-green-600"
                              placeholder="Recommandations convenues lors de l'appel..."></textarea>
                </div>

                <div class="bg-green-50 p-4 rounded-lg mb-4">
                    <p class="text-lg">Honoraires: <span class="font-bold text-green-700">${specialiste.tarif} DH</span></p>
                </div>

                <div class="flex justify-end gap-4">
                    <a href="${pageContext.request.contextPath}/specialiste/dashboard-specialiste"
                       class="px-6 py-3 bg-gray-200 rounded-lg hover:bg-gray-300">Annuler</a>
                    <button type="submit" class="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700">
                        Confirmer la Consultation
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function selectMode(mode) {
        document.querySelectorAll('.mode-card').forEach(card => card.classList.remove('selected'));

        if (mode === 'ECRITE') {
            document.getElementById('modeEcrite').checked = true;
            document.getElementById('modeEcrite').closest('.mode-card').classList.add('selected');
            document.getElementById('formEcrite').style.display = 'block';
            document.getElementById('formTelephone').style.display = 'none';
        } else {
            document.getElementById('modeTelephone').checked = true;
            document.getElementById('modeTelephone').closest('.mode-card').classList.add('selected');
            document.getElementById('formEcrite').style.display = 'none';
            document.getElementById('formTelephone').style.display = 'block';
        }
    }
</script>

</body>
</html>