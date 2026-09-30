<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set value="Inicio" var="pageTitle"/>
<%@ include file="components/header.jspf" %>

<section class="grid items-center gap-8 lg:grid-cols-[1.1fr_0.9fr] lg:gap-16">
    <div class="py-4 lg:py-8">
        <p class="mb-4 text-xs font-bold uppercase tracking-[0.24em] text-indigo-600">Gestión sencilla</p>
        <h1 class="font-display max-w-2xl text-4xl font-bold leading-[1.08] tracking-tight text-slate-950 sm:text-5xl lg:text-[4.25rem]">
            Todo tu catálogo, siempre en orden.
        </h1>
        <p class="mt-6 max-w-xl text-base leading-7 text-slate-600 sm:text-lg">
            Administra libros, registra préstamos y controla devoluciones desde un solo lugar.
        </p>
        <div class="mt-8 flex flex-wrap gap-3">
            <a class="rounded-xl bg-indigo-600 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-indigo-200 transition hover:-translate-y-0.5 hover:bg-indigo-700"
               href="${pageContext.request.contextPath}/app/libros/nuevo">
                Registrar libro
            </a>
            <a class="rounded-xl border border-slate-300 bg-white px-5 py-3 text-sm font-bold text-slate-700 transition hover:border-indigo-300 hover:text-indigo-700"
               href="${pageContext.request.contextPath}/app/libros">
                Ver catálogo
            </a>
        </div>
    </div>
    <div class="relative overflow-hidden rounded-[2rem] bg-indigo-800 p-7 text-white shadow-2xl shadow-indigo-100 sm:p-9">
        <div class="absolute -right-16 -top-20 h-48 w-48 rounded-full bg-indigo-700/30 blur-2xl"></div>
        <p class="relative text-xs font-bold uppercase tracking-[0.2em] text-indigo-300">Estado actual</p>
        <div class="relative mt-8 grid grid-cols-2 gap-4">
            <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                <p class="text-4xl font-bold tracking-tight">
                    <c:out value="${totalLibros}"/>
                </p>
                <p class="mt-2 text-sm text-indigo-200">Libros registrados</p></div>
            <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                <p class="text-4xl font-bold tracking-tight">
                    <c:out value="${totalPrestamosActivos}"/>
                </p>
                <p class="mt-2 text-sm text-indigo-200">Préstamos activos</p>
            </div>
        </div>
        <div class="relative mt-5 flex gap-3 rounded-2xl border border-indigo-700/70 bg-indigo-900/70 p-4 text-sm leading-6 text-indigo-100">
            <span class="mt-0.5 text-indigo-300">✦</span>
            <span>La disponibilidad se actualiza automáticamente al prestar y devolver un libro.</span>
        </div>
    </div>
</section>

<section class="mt-16">
    <div class="mb-6 flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
        <div><p class="text-xs font-bold uppercase tracking-[0.2em] text-indigo-600">Catálogo</p>
            <h2 class="mt-2 font-display text-3xl font-bold text-slate-950">Libros recientes</h2>
        </div>
        <a class="text-sm font-bold text-indigo-600 hover:text-indigo-800"
           href="${pageContext.request.contextPath}/app/libros">Ver todos
            <span aria-hidden="true">→</span>
        </a>
    </div>
    <div class="grid gap-5 md:grid-cols-3">
        <c:forEach begin="0" end="2" items="${libros}" var="libro">
            <article
                    class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-1 hover:shadow-lg hover:shadow-slate-200/70">
                <div class="mb-5 flex h-28 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-50 to-violet-100 text-5xl text-indigo-300">
                    ▤
                </div>
                <h3 class="font-semibold text-slate-900">
                    <c:out value="${libro.titulo}"/>
                </h3>
                <p class="mt-1 text-sm text-slate-500">
                    <c:out value="${libro.autor}"/>
                </p>
                <span class="mt-4 inline-flex rounded-full px-3 py-1 text-xs font-bold ${libro.estado == 'DISPONIBLE' ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}">
                    <c:out value="${libro.estado}"/>
                </span>
            </article>
        </c:forEach>
        <c:if test="${empty libros}">
            <div class="rounded-2xl border border-dashed border-slate-300 bg-white p-8 text-center md:col-span-3">
                <div class="mx-auto grid h-12 w-12 place-items-center rounded-2xl bg-indigo-50 text-xl text-indigo-600">
                    +
                </div>
                <h3 class="mt-4 font-semibold text-slate-900">Tu catálogo está listo para empezar</h3>
                <p class="mx-auto mt-2 max-w-md text-sm leading-6 text-slate-500">
                    Todavía no hay libros registrados. Agrega el primero para comenzar a gestionar préstamos.
                </p>
                <a class="mt-5 inline-flex rounded-lg bg-indigo-600 px-4 py-2 text-sm font-bold text-white hover:bg-indigo-700"
                   href="${pageContext.request.contextPath}/app/libros/nuevo">
                    Registrar primer libro
                </a>
            </div>
        </c:if>
    </div>
</section>

<%@ include file="components/footer.jspf" %>
