Vue.component('employee', function (resolve) {
    $.get(getRootDir() + '/js/app/component/employeeComponent.html', function (template) {
        resolve({
            props: ['item'],
            template:template
        })
    })
})