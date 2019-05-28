package mn.ddishtv.demo.server.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.jwt.Jwt;
import org.springframework.security.jwt.JwtHelper;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import mn.ddishtv.demo.server.domain.User;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {
	private final String KHANBANK_AUTH_URL = "http://localhost:9080/api/authenticate";

	@Autowired
	private RestTemplate restTemplate;

    public CustomAuthenticationProvider() {
        super();
    }

    // API

    @Override
    public Authentication authenticate(final Authentication authentication) throws AuthenticationException {
        final String username = authentication.getName();
        final String password = authentication.getCredentials().toString();

        try {
//			HttpHeaders headers = new HttpHeaders();
//			headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//			MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
//			map.add("username", username);
//			map.add("password", password);
//
//			HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(map,
//					headers);
//			ResponseEntity<String> postForEntity = restTemplate.postForEntity(KHANBANK_AUTH_URL, request, String.class);
//			if (!postForEntity.getStatusCode().equals(HttpStatus.OK))
//				throw new RestClientException("Bad Credentials.");
//
//			List<String> authorization = postForEntity.getHeaders().get(HttpHeaders.AUTHORIZATION);
//			String token = authorization.stream().findFirst().filter(o -> o.startsWith("Bearer ")).get()
//					.replaceAll("Bearer ", "");
//			User user = decodeJwt(token);

			return new UsernamePasswordAuthenticationToken(username, password, null);
		} catch (Exception exception) {
			exception.printStackTrace();
			return null;
		}
	}

	private User decodeJwt(String bearerToken) {
		ObjectMapper mapper = new ObjectMapper();
		User user = null;
		Jwt decode = JwtHelper.decode(bearerToken);

		try {
			user = mapper.readValue(decode.getClaims(), User.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

    @Override
    public boolean supports(final Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

}