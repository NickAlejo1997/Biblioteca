<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set value="Error" var="pageTitle"/>
<%@ include file="../components/header.jspf" %>
<div class="mx-auto max-w-xl rounded-2xl border border-rose-200 bg-white p-8 text-center shadow-sm">
    <div class="mx-auto grid h-14 w-14 place-items-center rounded-full bg-rose-100 text-2xl text-rose-600">!</div>
    <h1 class="mt-5 font-display text-3xl font-bold text-slate-900">No se pudo completar la operación</h1>
    <p class="mt-3 text-slate-600">
        <c:out value="${error}"/>
    </p>
    <a class="mt-7 inline-block rounded-xl bg-indigo-600 px-5 py-3 font-semibold text-white hover:bg-indigo-700"
       href="${pageContext.request.contextPath}/app/inicio">
        Volver al inicio
    </a>
</div>
<%@ include file="../components/footer.jspf" %>
